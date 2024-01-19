use std::sync::mpsc;
use std::thread;

pub trait Task {
    type Output: Send;
    fn run(&self) -> Option<Self::Output>;
}

pub struct WorkQueue<TaskType: 'static + Task + Send> {
    send_tasks: Option<spmc::Sender<TaskType>>, // Option because it will be set to None to close the queue
    recv_tasks: spmc::Receiver<TaskType>,
    //send_output: mpsc::Sender<TaskType::Output>, // not need in the struct: each worker will have its own clone.
    recv_output: mpsc::Receiver<TaskType::Output>,
    workers: Vec<thread::JoinHandle<()>>,
}

impl<TaskType: 'static + Task + Send> WorkQueue<TaskType> {
    pub fn new(n_workers: usize) -> WorkQueue<TaskType> {
        // TODO: create the channels; start the worker threads; record their JoinHandles
        let (s1, r1) = spmc::channel::<TaskType>();
        let (s2, r2) = mpsc::channel::<TaskType::Output>();
        let mut vec = Vec::new();
        let mut index = 0;
        while index < n_workers{
            let recv_tasks = r1.clone();
            let send_output = s2.clone();
            vec.push(thread::spawn(move || {WorkQueue::run(recv_tasks, send_output);}));
            index+=1;
        }
        let wq = WorkQueue {
            send_tasks: Some(s1),
            recv_tasks: r1,
            recv_output: r2,
            workers:vec,
        };
        return wq;
    }

    fn run(recv_tasks: spmc::Receiver<TaskType>, send_output: mpsc::Sender<TaskType::Output>) {
        // TODO: the main logic for a worker thread
        loop {
            let task_result = recv_tasks.recv();
            // NOTE: task_result will be Err() if the spmc::Sender has been destroyed and no more messages can be received here
            match task_result{
                Err(e) => break,              
                Ok(t) => {
                    match t.run(){
                        Some(r) => {send_output.send(r).unwrap();}
                        None => {}
                    };
                }
                
            }
        }
    }

    pub fn enqueue(&mut self, t: TaskType) -> Result<(), spmc::SendError<TaskType>> {
        // TODO: send this task to a worker
        let mut sender_tasks = self.send_tasks.as_mut();
        let send = sender_tasks.unwrap();
        return send.send(t);
    }

    // Helper methods that let you receive results in various ways
    pub fn iter(&mut self) -> mpsc::Iter<TaskType::Output> {
        self.recv_output.iter()
    }
    pub fn recv(&mut self) -> TaskType::Output {
        self.recv_output
            .recv()
            .expect("I have been shutdown incorrectly")
    }
    pub fn try_recv(&mut self) -> Result<TaskType::Output, mpsc::TryRecvError> {
        self.recv_output.try_recv()
    }
    pub fn recv_timeout(
        &self,
        timeout: std::time::Duration,
    ) -> Result<TaskType::Output, mpsc::RecvTimeoutError> {
        self.recv_output.recv_timeout(timeout)
    }

    pub fn shutdown(&mut self) {
        // TODO: destroy the spmc::Sender so everybody knows no more tasks are incoming;
        // drain any pending tasks in the queue; wait for each worker thread to finish.
        // HINT: Vec.drain(..)
        self.send_tasks = None;
        loop {
                let result = self.recv_tasks.recv();
                match result {
                    Err(_) => break,
                    Ok(_) => {}
            }
        }
        let workers = self.workers.drain(..);
        for worker in workers {
            worker.join().unwrap();
        }
    
    }
}

impl<TaskType: 'static + Task + Send> Drop for WorkQueue<TaskType> {
    fn drop(&mut self) {
        // "Finalisation in destructors" pattern: https://rust-unofficial.github.io/patterns/idioms/dtor-finally.html
        match self.send_tasks {
            None => {} // already shut down
            Some(_) => self.shutdown(),
        }
    }
}

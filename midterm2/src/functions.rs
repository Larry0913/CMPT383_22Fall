fn push_and_get_index<T>(v: &mut Vec<T>, item: T) -> usize {
    let idx = v.len();
    v.push(item);
    idx
}

#[derive(Debug, PartialEq, Clone)]
pub struct DLL {
    pub elems: Vec<Node>,
    pub first_last: Option<(usize, usize)>,
    pub len: usize,
}

#[derive(Debug, PartialEq, Clone)]
pub struct Node {
    pub prev: Option<usize>,
    pub data: i32,
    pub next: Option<usize>,
}

pub fn empty() -> DLL {
    return DLL {
        elems: vec![],
        first_last: None,
        len: 0,
    };
}

pub fn get_elem_index_of(dll: &DLL, index: usize) -> Option<usize> {
    //unimplemented!()
    if dll.elems.is_empty() || index >= dll.len {
        return None;
    }
    let mut vec1 = Vec::new();
    let (first, last) = dll.first_last.unwrap();
    let mut vec2 = vec![first];
    let mut i = 0;
    let mut j = 0;

    for node in &dll.elems {
        if node.prev == None {
            vec1.push(node);
            i += 1;
            break;
        }
    }
    for node in &dll.elems {
        if node.prev != None && node.prev.unwrap() == first {
            vec1.push(node);
            vec2.push(vec1[0].next.unwrap());
            i += 1;
            break;
        }
    }

    while i < dll.elems.len() {
        for node in &dll.elems {
            if node.prev != None && vec1[j].next != None {
                if node.prev.unwrap() == vec1[j].next.unwrap() {
                    vec1.push(node);
                    vec2.push(vec1[j + 1].next.unwrap());
                    j += 1;
                    i += 1;
                    break;
                }
            }
        }
    }
    return Some(vec2[index]);
}

pub fn insert_at(dll: &mut DLL, index: usize, data: i32) {
    //unimplemented!()
    let mut insert_node = Node {
        prev: None,
        data,
        next: None,
    };
    if dll.elems.len() == 0 {
        dll.elems.push(insert_node);
        dll.len += 1;
        dll.first_last = Some((0, 0));
    } else {
        let (first, last) = dll.first_last.unwrap();
        let mut i = 0;
        let mut vec = Vec::new();
        while i < dll.elems.len() {
            vec.push(get_elem_index_of(dll, i).unwrap());
            i += 1;
        }
        if index == 0 {
            insert_node.next = Some(vec[0]);
            let new_index = push_and_get_index(&mut dll.elems, insert_node);
            let mut j = 0;
            while j < dll.elems.len() - 1 {
                if dll.elems[j].prev == None {
                    dll.elems[j].prev = Some(new_index);
                }
                j += 1;
            }
            dll.len += 1;
            dll.first_last = Some((new_index, last));
        } else if index == dll.elems.len() {
            insert_node.prev = Some(vec[vec.len() - 1]);
            let new_index = push_and_get_index(&mut dll.elems, insert_node);
            let mut j = 0;
            while j < dll.elems.len() - 1 {
                if dll.elems[j].next == None {
                    dll.elems[j].next = Some(new_index);
                }
                j += 1;
            }
            dll.len += 1;
            dll.first_last = Some((first, new_index));
        } else {
            insert_node.prev = Some(vec[index - 1]);
            insert_node.next = Some(vec[index]);
            let new_index = push_and_get_index(&mut dll.elems, insert_node);
            let mut j = 0;
            while j < dll.elems.len() - 1 {
                if dll.elems[j].prev == Some(vec[index - 1]) {
                    dll.elems[j].prev = Some(new_index);
                }
                if dll.elems[j].next == Some(vec[index]) {
                    dll.elems[j].next = Some(new_index);
                }
                j += 1;
            }
            dll.len += 1;
        }
    }
}

fn insert_at_front(dll: &mut DLL, data: i32) {
    insert_at(dll, 0, data);
}

pub fn insert_all_at_front<'a>(vec: &'a Vec<i32>, dll: &'a mut DLL) -> &'a Node {
    for i in vec {
        insert_at_front(dll, *i);
    }
    return dll.elems.last().unwrap();
    //return &dll.elems[dll.len - 1];
}

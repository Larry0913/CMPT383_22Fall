fn push_and_get_index<T>(v: &mut Vec<T>, item: T) -> usize {
    let idx = v.len();
    v.push(item);
    idx
}

#[derive(Debug,PartialEq,Clone)]
pub struct DLL {
    pub elems: Vec<Node>,
    pub first_last: Option<(usize,usize)>,
    pub len: usize,
}

#[derive(Debug,PartialEq,Clone)]
pub struct Node {
    pub prev: Option<usize>,
    pub data: i32,
    pub next: Option<usize>
}

pub fn empty() -> DLL {
    return DLL {
        elems: vec![],
        first_last: None,
        len: 0,
    }
}

// Write the function get_elem_index_of that will retrieve the index (in the vector)
// of the element at the provided index (in the doubly-linked list).
// For example, say we have the doubly linked list where elems = vec![n0,n1,n2] and first_last = Some((1,0)),
// where n0 has no next, and a previous of 2. n1 has a next of 2 and has no previous. n2 has a next of 0
// and a previous of 1. In this example, the linked list beings at index 1 with n1 (as represented by the first
// element of the tuple in first_last being 0, and having no previous index). It then proceeds to the next
// element, which is at index 2, so n2. n2 is the middle element, pointing previously to index 1, and next to
// index 0. At index 0 is n0, the last node. So, calling get_elem_index_of(dll,0) would return Some 1.
// get_elem_index_of(dll,1) would return Some 2. get_elem_index_of(dll,2) would return Some 0.
// Calling with any other index would return None. More examples are provided in the tests.
pub fn get_elem_index_of(dll: &DLL, index: usize) -> Option<usize> {
    if let Some((first, _)) = dll.first_last {
        let mut iter = first;
        let mut counter = 0;
        while let Some(node) = dll.elems.get(iter) {
            if index == counter {
                return Some(iter);
            } else {
                counter += 1;
                iter = if let Some(next) = node.next {
                    next
                } else {
                    break;
                };
            }
        }
    }

    None
}


// Write the function insert_at that will update the DLL to insert a given piece of data
// at a provided index. The length of the list should be increased, and all the pointers should be adjusted
// to reflect this insertion. The push_and_get_index function will be helpful here. If an invalid index is
// provided (in other words, the index is not between 0 and dll.length inclusive) you can do any behavior.
// We will always provide valid indexes while testing.
pub fn insert_at(dll: &mut DLL, index: usize, data: i32) {    
    let mut new_node = Node{prev:None, data:data, next:None};
    if let None = dll.first_last {
        push_and_get_index(&mut dll.elems, new_node);
        dll.len = 1;
        dll.first_last = Some((0, 0));
    } else {
        let (first, last) = dll.first_last.unwrap();
        if index >= dll.len {
            new_node.prev = Some(last);
            let idx = push_and_get_index(&mut dll.elems, new_node);
            let last_node = dll.elems.get_mut(last).unwrap();
            last_node.next = Some(idx);
            dll.first_last = Some((first, idx));
            dll.len += 1;
        } else {
            let i_ele = get_elem_index_of(dll, index).unwrap();
            let mut ele = dll.elems.get_mut(i_ele).unwrap();
            new_node.prev = ele.prev.clone();
            ele.prev = Some(dll.len);
            new_node.next = Some(i_ele);
            if let None = new_node.prev {
                dll.first_last = Some((dll.len, last));
            } else {
                let p_node = dll.elems.get_mut(new_node.prev.unwrap()).unwrap();
                p_node.next = Some(dll.len);
            }
            dll.len+=1;
            push_and_get_index(&mut dll.elems, new_node);
        }
    }
}

fn insert_at_front(dll:&mut DLL, data:i32) {
    insert_at(dll, 0, data);
}

// Write the function insert_all_at_front. This function should take in a reference
// to a vector of values as the first input, and a mutable reference to a DLL. It should then insert each of those
// values into the front of the DLL (potentially via the insert_at_front function). Then, a reference to the
// node at index 0 should be returned. You must write the function signature for this question. The tests
// have been commented out to enable compilation
pub fn insert_all_at_front<'a>(queue: &Vec<i32>, dll: &'a mut DLL)->&'a Node {
    for item in queue {
        insert_at_front(dll, *item);
    }

    return dll.elems.last().unwrap();
}

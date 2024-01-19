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
/// Write the function get_elem_index_of that will retrieve the index (in the vector)
/// of the element at the provided index (in the doubly-linked list).
/// For example, say we have the doubly linked list where elems = vec![n0,n1,n2] and first_last = Some((1,0)),
/// where n0 has no next, and a previous of 2. n1 has a next of 2 and has no previous. n2 has a next of 0
/// and a previous of 1. In this example, the linked list beings at index 1 with n1 (as represented by the first
/// element of the tuple in first_last being 0, and having no previous index). It then proceeds to the next
/// element, which is at index 2, so n2. n2 is the middle element, pointing previously to index 1, and next to
/// index 0. At index 0 is n0, the last node. So, calling get_elem_index_of(dll,0) would return Some 1.
/// get_elem_index_of(dll,1) would return Some 2. get_elem_index_of(dll,2) would return Some 0.
/// Calling with any other index would return None. More examples are provided in the tests
pub fn get_elem_index_of(dll: &DLL, index: usize) -> Option<usize> {
    match dll.first_last {
        Some((begin, _)) => {
            let mut i = begin;
            let mut counter = 0;
            while let Some(n) = dll.elems.get(i) {
                if counter == index {
                    return Some(i);
                } else {
                    counter += 1;
                    i = if let Some(next) = n.next {
                        next
                    } else {
                        break;
                    };
                }
            }
            None
        }
        None => None,
    }
}

/// Write the function insert_at that will update the DLL to insert a given piece of data
/// at a provided index. The length of the list should be increased, and all the pointers should be adjusted
/// to reflect this insertion. The push_and_get_index function will be helpful here. If an invalid index is
/// provided (in other words, the index is not between 0 and dll.length inclusive) you can do any behavior.
/// We will always provide valid indexes while testing.
pub fn insert_at(dll: &mut DLL, index: usize, data: i32) {
    let idx = push_and_get_index(
        &mut dll.elems,
        Node {
            prev: None,
            data: data,
            next: None,
        },
    );
    dll.len = idx + 1;

    let i = get_elem_index_of(dll, index);
    match i {
        Some(i) => {
            let ele = dll.elems.get_mut(i).unwrap();
            let prev = ele.prev.clone();
            ele.prev = Some(idx);
            dll.elems.last_mut().unwrap().next = Some(i);
            dll.elems.last_mut().unwrap().prev = prev;
            let (_, last) = dll.first_last.unwrap();
            match prev {
                None=>{
                    dll.first_last = Some((idx, last))
                }
                Some(p)=>{
                    dll.elems.get_mut(p).unwrap().next = Some(idx);
                }
            };
        }
        None => {          
            if let Some((first, last)) = dll.first_last.take() {
                dll.elems.last_mut().unwrap().prev = Some(last);
                dll.elems.get_mut(last).unwrap().next = Some(idx);
                dll.first_last = Some((first, idx));
            } else {
                dll.first_last = Some((idx, idx));
            }
        }
    };
}

fn insert_at_front(dll: &mut DLL, data: i32) {
    insert_at(dll, 0, data);
}

/// Write the function insert_all_at_front. This function should take in a reference
/// to a vector of values as the first input, and a mutable reference to a DLL. It should then insert each of those
/// values into the front of the DLL (potentially via the insert_at_front function). Then, a reference to the
/// node at index 0 should be returned. You must write the function signature for this question. The tests
/// have been commented out to enable compilation.
pub fn insert_all_at_front<'a>(eles: &[i32], dll: &'a mut DLL) -> &'a Node {
    eles.iter().for_each(|x| {
        insert_at_front(dll, *x);
    });
    return dll.elems.last().unwrap();
}

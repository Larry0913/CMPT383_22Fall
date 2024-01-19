mod functions;

#[cfg(test)]
mod get_elem_index_of_tests {
    use crate::functions::{*};

    #[test]
    fn get_elem_index_of_tests_0() {
        assert_eq!(None,get_elem_index_of(&empty(), 0))
    }

    #[test]
    fn get_elem_index_of_tests_1() {
        let dll = DLL {
            elems : vec![Node { prev:None, data:2, next:None }],
            first_last : Some((0,0)),
            len : 1,
        };
        assert_eq!(Some(0),get_elem_index_of(&dll, 0));
        assert_eq!(None,get_elem_index_of(&dll, 1));
    }

    #[test]
    fn get_elem_index_of_tests_2() {
        let dll = DLL {
            elems : vec![Node { prev:Some(1), data:2, next:None }
                        ,Node { prev:None, data:5, next:Some(0) }],
            first_last : Some((1,0)),
            len : 2,
        };
        assert_eq!(Some(1),get_elem_index_of(&dll, 0));
        assert_eq!(Some(0),get_elem_index_of(&dll, 1));
        assert_eq!(None,get_elem_index_of(&dll, 2));
    }

    #[test]
    fn get_elem_index_of_tests_3() {
        let dll = DLL {
            elems : vec![Node { prev:Some(2), data:2, next:None }
                        ,Node { prev:None, data:5, next:Some(2) }
                        ,Node { prev:Some(1), data:5, next:Some(0) }
                        ],
            first_last : Some((1,0)),
            len : 3,
        };
        assert_eq!(Some(1),get_elem_index_of(&dll, 0));
        assert_eq!(Some(2),get_elem_index_of(&dll, 1));
        assert_eq!(Some(0),get_elem_index_of(&dll, 2));
        assert_eq!(None,get_elem_index_of(&dll, 3));
    }

    #[test]
    fn get_elem_index_of_tests_4() {
        let dll = DLL {
            elems : vec![Node { prev:None, data:3, next:Some(1) }
                        ,Node { prev:Some(0), data:8, next:Some(2) }
                        ,Node { prev:Some(1), data:5, next:None }],
            first_last : Some((0,2)),
            len : 3,
        };
        assert_eq!(Some(0),get_elem_index_of(&dll, 0));
        assert_eq!(Some(1),get_elem_index_of(&dll, 1));
        assert_eq!(Some(2),get_elem_index_of(&dll, 2));
        assert_eq!(None,get_elem_index_of(&dll, 3));
    }
}

#[cfg(test)]
mod insert_at_tests {
    use crate::functions::{*};

    #[test]
    fn insert_at_tests_0() {
        let mut updated_dll = empty();
        let target_dll = DLL {
            elems : vec![Node { prev:None, data:3, next:None }],
            first_last : Some((0,0)),
            len : 1,
        };
        insert_at(& mut updated_dll, 0, 3);
        assert_eq!(target_dll,updated_dll);
    }

    #[test]
    fn insert_at_tests_1() {
        let mut updated_dll = empty();
        let target_dll = DLL {
            elems : vec![Node { prev:None, data:3, next:Some(1) }
                        ,Node { prev:Some(0), data:8, next:None }],
            first_last : Some((0,1)),
            len : 2,
        };
        insert_at(& mut updated_dll, 0, 3);
        insert_at(& mut updated_dll, 1, 8);
        assert_eq!(target_dll,updated_dll);
    }

    #[test]
    fn insert_at_tests_2() {
        let mut updated_dll = empty();
        let target_dll = DLL {
            elems : vec![Node { prev:Some(1), data:3, next:None }
                        ,Node { prev:None, data:8, next:Some(0) }],
            first_last : Some((1,0)),
            len : 2,
        };
        insert_at(& mut updated_dll, 0, 3);
        insert_at(& mut updated_dll, 0, 8);
        assert_eq!(target_dll,updated_dll);
    }

    #[test]
    fn insert_at_tests_3() {
        let mut updated_dll = empty();
        let target_dll = DLL {
            elems : vec![Node { prev:None, data:3, next:Some(1) }
                        ,Node { prev:Some(0), data:8, next:Some(2) }
                        ,Node { prev:Some(1), data:5, next:None }],
            first_last : Some((0,2)),
            len : 3,
        };
        insert_at(& mut updated_dll, 0, 3);
        insert_at(& mut updated_dll, 1, 8);
        insert_at(& mut updated_dll, 2, 5);
        assert_eq!(target_dll,updated_dll);
    }

    #[test]
    fn insert_at_tests_4() {
        let mut updated_dll = empty();
        let target_dll = DLL {
            elems : vec![Node { prev:None, data:3, next:Some(2) }
                        ,Node { prev:Some(2), data:8, next:None }
                        ,Node { prev:Some(0), data:5, next:Some(1) }],
            first_last : Some((0,1)),
            len : 3,
        };
        insert_at(& mut updated_dll, 0, 3);
        insert_at(& mut updated_dll, 1, 8);
        insert_at(& mut updated_dll, 1, 5);
        assert_eq!(target_dll,updated_dll);
    }

    #[test]
    fn insert_at_tests_5() {
        let mut updated_dll = empty();
        let target_dll = DLL {
            elems : vec![Node { prev:Some(2), data:3, next:None }
                        ,Node { prev:None, data:8, next:Some(2) }
                        ,Node { prev:Some(1), data:5, next:Some(0) }
                        ],
            first_last : Some((1,0)),
            len : 3,
        };
        insert_at(& mut updated_dll, 0, 3);
        insert_at(& mut updated_dll, 0, 8);
        insert_at(& mut updated_dll, 1, 5);
        assert_eq!(target_dll,updated_dll);
    }
}

#[cfg(test)]
mod insert_all_at_front_tests {
    use crate::functions::{*};

    #[test]
    fn insert_all_at_front_tests_0() {
        let mut updated_dll = empty();
        let target_dll = DLL {
            elems : vec![Node { prev:Some(1), data:3, next:None }
                        ,Node { prev:Some(2), data:8, next:Some(0) }
                        ,Node { prev:None, data:5, next:Some(1) }
                        ],
            first_last : Some((2,0)),
            len : 3,
        };
        let insertion_queue = vec![3,8,5];
        let n = (*insert_all_at_front(&insertion_queue, & mut updated_dll)).clone();
        assert_eq!(target_dll,updated_dll);
        assert_eq!(Node {prev:None,data:5,next:Some(1)},n);
    }

    #[test]
    fn insert_all_at_front_tests_1() {
        let mut updated_dll = DLL {
            elems : vec![Node { prev:None, data:13, next:Some(1) }
                        ,Node { prev:Some(0), data:18, next:Some(2) }
                        ,Node { prev:Some(1), data:15, next:None }],
            first_last : Some((0,2)),
            len : 3,
        };
        let target_dll = DLL {
            elems : vec![Node { prev:Some(3), data:13, next:Some(1) }
                        ,Node { prev:Some(0), data:18, next:Some(2) }
                        ,Node { prev:Some(1), data:15, next:None }
                        ,Node { prev:Some(4), data:3, next:Some(0) }
                        ,Node { prev:Some(5), data:8, next:Some(3) }
                        ,Node { prev:None, data:5, next:Some(4) }
                        ],
            first_last : Some((5,2)),
            len : 6,
        };
        let insertion_queue = vec![3,8,5];
        let n = (*insert_all_at_front(&insertion_queue, & mut updated_dll)).clone();
        assert_eq!(target_dll,updated_dll);
        assert_eq!(Node {prev:None,data:5,next:Some(4)},n);
    }
}

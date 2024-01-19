pub fn next_hailstone(x:u32) -> u32 {
    //unimplemented!();
    if x % 2 == 0{
        x/2
    }
    else{
        3 * x + 1
    }
}

pub fn hailstone_sequence(init:u32) -> Vec<u32> {
    //unimplemented!();
    let mut v: Vec<u32> = Vec::new();
    let mut n = init;
    v.push(n);
    while n != 1 {
        if n % 2 == 0{
            n = n/2;
        }
        else{
            n = 3 * n + 1;
        }
        v.push(n)
    }
    return v
}

pub fn find_elt<T : Eq>(v: Vec<T>,elt: T) -> Option<usize> {
    //unimplemented!();
    let size = v.len();
    let mut index = 0;
    while index < size{
        if v[index] == elt{ 
            return Some(index);
        }
        index+=1;
    }
    None
}

pub fn all_indices<T : Eq>(v: Vec<T>,elt: T) -> Vec<usize> {
    //unimplemented!();
    let size = v.len();
    let mut temp_v: Vec<usize> = Vec::new();
    let mut index = 0;
    while index < size{
        if v[index] == elt{
            temp_v.push(index);
        }
        index+=1;
    }
    return temp_v;
}
pub mod cnf_formula;
use cnf_formula::*;

pub fn find_propogatable(f: &Formula) -> Option<(Variable, bool)> {
    //unimplemented!()
    for c in f {
        if c.len() == 1 {
            for a in c {
                match a {
                    Atom::Base(v) => return Some((*v, true)),
                    Atom::Not(v) => return Some((*v, false)),
                }
            }
        }
    }
    None
}

pub fn propogate_unit(f: &mut Formula, v: Variable, b: bool) {
    //unimplemented!()
    let mut index0 = 0;
    let mut index1;
    let mut count1 = 0;
    let mut count2;
    for c in f.clone() {
        index1 = 0;
        count2 = 0;
        for a in c {
            if b == true {
                match a {
                    Atom::Base(vp) => {
                        if vp == v {
                            //vec1.push(index0)
                            f.remove(index0 - count1);
                            count1 += 1;
                        }
                    }
                    Atom::Not(vp) => {
                        if vp == v {
                            f[index0 - count1].remove(index1 - count2);
                            count2 += 1;
                        }
                    }
                }
            } else {
                match a {
                    Atom::Not(vp) => {
                        if vp == v {
                            f.remove(index0 - count1);
                            count1 += 1;
                        }
                    }
                    Atom::Base(vp) => {
                        if vp == v {
                            f[index0 - count1].remove(index1 - count2);
                            count2 += 1;
                        }
                    }
                }
            }
            index1 += 1;
        }
        index0 += 1;
    }
}

pub fn find_pure_var(f: &Formula) -> Option<Variable> {
    //unimplemented!()
    let vec1: Vec<Variable> = get_vars(f);

    for vp in vec1 {
        if is_pure(f, vp) == true {
            return Some(vp);
        }
    }
    return None;
}

pub fn assign_pure_var(f: &mut Formula, v: Variable) {
    //unimplemented!()
    let mut index = 0;
    let mut count = 0;
    for c in f.clone() {
        if has_var_clause(&c, v) {
            f.remove(index - count);
            count += 1;
        }
        index += 1;
    }
}

pub fn unit_propogate(f: &mut Formula) {
    match find_propogatable(f) {
        Option::None => return,
        Option::Some((v, b)) => {
            propogate_unit(f, v, b);
            unit_propogate(f)
        }
    }
}

pub fn assign_pure_vars(f: &mut Formula) {
    match find_pure_var(f) {
        Option::None => return,
        Option::Some(v) => {
            assign_pure_var(f, v);
            assign_pure_vars(f);
        }
    }
}

pub fn dpll(f: &mut Formula) -> bool {
    //unimplemented!()
    let mut f = f.to_vec();
    unit_propogate(&mut f);
    assign_pure_vars(&mut f);
    if f.is_empty() {
        return true;
    }

    if f.iter().any(|clause| clause.is_empty()) {
        return false;
    }

    let var = find_most_used_variable(&f);
    f.push(vec![Atom::Base(var)]);
    if dpll(&mut f) {
        return true;
    }

    f.pop();
    f.push(vec![Atom::Not(var)]);
    dpll(&mut f)
}

fn find_most_used_variable(f: &Formula) -> Variable {
    let mut v = Vec::new();
    let mut most_used_variable = ' ';

    for c in f {
        for a in c {
            match a {
                &Atom::Base(vp) => v.push(vp),
                &Atom::Not(vp) => v.push(vp),
            };
        }
    }
    v.sort_unstable();
    let mut maxcount = 0;
    let mut index1 = 0;
    let mut index2;
    while index1 < v.len() {
        let mut count = 0;
        index2 = 0;
        while index2 < v.len() {
            if v[index1] == v[index2] {
                count += 1;
            }
            index2 += 1;
        }
        if count > maxcount {
            maxcount = count;
            most_used_variable = v[index1];
        }
        index1 += 1;
    }
    return most_used_variable;
}

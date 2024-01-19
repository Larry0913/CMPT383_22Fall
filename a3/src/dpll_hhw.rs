pub mod cnf_formula;
use cnf_formula::*;

pub fn find_propogatable(f:& Formula) -> Option<(Variable,bool)> {
    //unimplemented!()
    for clause in f{
        if clause.len() == 1 {
            for a in clause{
                match a{
                    Atom::Base(v) => return Some((*v, true)),
                    Atom::Not(v) => return Some((*v, false)),
                }
            } 
        }
    }
    return None
}

pub fn propogate_unit(f:& mut Formula,v:Variable,b:bool) {
    //unimplemented!()
    if b == false{
        f.retain(|v_temp| !v_temp.contains(&Atom:: Not(v)));
        for v_temp in f{
            v_temp.retain(|x| x != &Atom:: Base(v));
        }
    }
    else if b == true{
        f.retain(|v_temp| !v_temp.contains(&Atom:: Base(v)));
        for v_temp in f{
            v_temp.retain(|x| x != &Atom:: Not(v));
        }
    }
   
}

pub fn find_pure_var(f:& Formula) -> Option<Variable> {
    //unimplemented!()
    let v_temp: Vec<Variable> = get_vars(f);

    for v in v_temp{
        if is_pure(f, v) == true{
            return  Some(v);
        }
        else if is_pure(f, v) == false{
            continue;
        }
    }
    return  None;
}

pub fn assign_pure_var(f: & mut Formula, v: Variable) {
    //unimplemented!()
    let mut index = 0;
    let mut number = 0;
    for v_temp in f.clone(){
        if has_var_clause(&v_temp, v){
            f.remove(index - number);
            number = number + 1;
        }
        index = index + 1;
    }
}

pub fn unit_propogate(f:& mut Formula) {
    match find_propogatable(f) {
        Option::None => return,
        Option::Some((v,b)) => {
            propogate_unit(f, v, b);
            unit_propogate(f)
        }
    }
}

pub fn assign_pure_vars(f:& mut Formula) {
    match find_pure_var(f) {
        Option::None => return,
        Option::Some(v) => {
            assign_pure_var(f,v);
            assign_pure_vars(f); 
        }
    }
}

pub fn dpll(f:& mut Formula) -> bool {
    //unimplemented!()
    if f.is_empty(){
        return true;
    }

    unit_propogate(f);
    assign_pure_vars(f);
    
    let v = get_vars(f);
    let mut f1 =f.clone();
    let mut f2 =f.clone();
    
    for c in f{
        if c.is_empty(){
            return false;
        }
    }

    for x in v{
        f1.push(vec![Atom:: Base(x)]);
        f2.push(vec![Atom:: Base(x)]);
    }

    return dpll(&mut f1) || dpll(&mut f2);
}
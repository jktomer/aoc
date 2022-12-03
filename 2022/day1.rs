// use std::env;
use std::fs;
use std::io;
use std::cmp;
use std::collections::BinaryHeap;

fn main() -> Result<(), io::Error>{
    let contents = fs::read_to_string("day1.txt")?;
    let mut h = BinaryHeap::new();
    let _ = contents.split("\n\n").map(
        |txt| txt.split('\n')
            .filter(|x| !x.is_empty())
            .map(|x| x.parse::<i32>().unwrap())
            .rfold(0, |acc, x| acc + x))
        .for_each(|x| {
            h.push(cmp::Reverse(x));
            if h.len() > 3 {
                h.pop();
            }
        });
    let max = h.iter().rfold(0, |acc, x| cmp::max(acc, (*x).0));
    let topthree = h.iter().rfold(0, |acc, x| acc + (*x).0);
    println!("{max} {topthree}");
    Ok(())
}

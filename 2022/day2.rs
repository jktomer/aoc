use std::fs;
use std::io;

fn score1((opp, you): (u8, u8)) -> i32 {
    let diff = (you + 4 - opp) % 3;
    (diff * 3 + you + 1) as i32
}

fn score2((opp, want): (u8, u8)) -> i32 {
    (want * 3 + (opp + want + 2) % 3 + 1) as i32
}

fn main() -> Result<(), io::Error>{
    let contents = fs::read_to_string("day2.txt")?;
    let scores = contents.split('\n')
        .filter(|l| !l.is_empty())
        .map(|u| u.as_bytes())
        .map(|b| (b[0] - b'A', b[2] - b'X'))
        .map(|x| (score1(x), score2(x)));
    let (total1, total2) = scores.rfold((0, 0), |(a1, a2), (x1, x2)| (a1+x1, a2+x2));
    println!("{total1} {total2}");
    Ok(())
}

#![allow(unused)]

use std::error::Error;

fn main() {
    println!("Hello, world!");
}

// Structs

struct Response {
    counter: u32,
    payload: String,
}

// Enums

enum Request {
    DeleteAll,
    Delete(String),
    Read { target: String, offset: Option<u32> },
}

// Functions

fn takes_request(req: Request) {
    match req {
        Request::DeleteAll => todo!(),
        Request::Delete(target) | Request::Read { target, .. } => todo!(),
    }
}

// separate from declaration..
impl Response {
    fn hello() {
        println!("Hello!");
    }
}

// Options

fn maybe_do(data: Option<u32>) {
    if let Some(data) = data {
        todo!()
    }
}

// Error handling: Results

fn try_do() -> Result<i32, String> {
    Err("not implemented".to_owned())
}

fn use_result() -> Result<(), Box<dyn Error>> {
    let v = try_do()?;
    let v = try_do().unwrap();

    let v = try_do().unwrap_or(0);

    let Ok(v) = try_do() else {
        panic!();
    };

    Ok(())
}

// Generics 1: Generic structs/functions without requirements

struct LinkedList<ITEM> {
    item: ITEM,
    next: Option<Box<LinkedList<ITEM>>>,
}

impl<ITEM> LinkedList<ITEM> {
    fn append(&mut self, item: ITEM) {
        let mut target = self;
        while let Some(ref mut next) = target.next {
            target = next;
        }
        target.next = Some(Box::new(LinkedList { item, next: None }))
    }
}

// Generics 2: Traits

trait MakesNoise {
    fn bark(&self);
}

fn uses_noise_generic<M: MakesNoise>() {}
fn uses_noise_impl_trait(m: impl MakesNoise) {}
fn uses_noise_dyn_dispatch(m: &dyn MakesNoise) {}

// Clean-up logic: Drop

struct WarnsOnDrop;

impl Drop for WarnsOnDrop {
    fn drop(&mut self) {
        println!("I think you forgot about me!");
    }
}

// will also warn on exit..
struct Contains(WarnsOnDrop);

// async

async fn op_1() {
    // does something that takes a long time..
}
async fn op_2() {
    // does something that takes a long time..
}

async fn op() {
    op_1().await;
    op_2().await;

    // join!(op_1(), op_2());
    // select!(op_1(), op_2());
}

// Tests

#[test]
fn test_something() {
    assert_eq!(false, true);
}

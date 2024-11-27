#[macro_use]
extern crate rocket;

use rocket::fs::{relative, FileServer};

#[launch]
fn rocket() -> _ {
    rocket::build()
        .mount("/", FileServer::from(relative!("static/")))
        .mount("/blog/", FileServer::from(relative!("blog/_site/")).rank(0))
}

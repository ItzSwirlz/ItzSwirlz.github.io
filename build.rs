use std::process::Command;

fn main() {
    println!("cargo::rerun-if-changed=static/less/");
    println!("cargo::rerun-if-changed=blog/");

    let output = Command::new("just").args(&["build"]).output().expect("");
    if !output.status.success() {
        panic!(
            "just build failed with error: {}",
            String::from_utf8_lossy(&output.stderr)
        );
    }
}

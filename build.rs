use std::process::Command;

fn main() {
    println!("cargo::rerun-if-changed=static/less/");

    let output = Command::new("lessc")
        .args(&["static/less/index.less", "static/index.css"])
        .output()
        .expect("");
    if !output.status.success() {
        panic!(
            "lessc failed with error: {}",
            String::from_utf8_lossy(&output.stderr)
        );
    }
}

extern crate serde_yaml;

use std::fs;
use std::path::Path;

pub fn pack(file: &str, version: &str) -> bool {
    // Check that the file exists...
    if !Path::new(file).exists() {
        println!("Unable to find file {} - are you sure it exists?", file);
        return false;
    }

    // Read file and parse
    println!("Reading {}", file);
    println!();

    let contents = fs::read_to_string(file).unwrap();
    let packfile: serde_yaml::Value = serde_yaml::from_str(&contents).unwrap();

    let package_as: &str = packfile["package-as"].as_str().unwrap();
    let has_version: bool = !version.trim().is_empty();
    let has_commands: bool = packfile["commands"].is_sequence();

    if has_version {
        println!("Packing as {}-{}", package_as, version);
    } else {
        println!("Packing as {}", package_as);
    }
    println!();

    // Attempt to copy to a temp directory
    if !copy_to_temp_dir() {
        println!("Unable to copy to temporary directory");
        return false;
    }

    // Check if we have any commands and run them
    if has_commands {
        println!("Executing commands");
        let commands = packfile["commands"].as_sequence().unwrap();

        for command in commands {
            println!("  - {}", command.as_str().unwrap());
        }
    }

    return true;
}

// Create and copy to a temporary directory before doing anything
// with the files.
fn copy_to_temp_dir() -> bool {
    return true;
}
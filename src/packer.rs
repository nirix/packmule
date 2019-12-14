extern crate serde_yaml;
extern crate tempdir;

use std::io;
use std::fs;
// use std::fmt;
use std::path::{Path, PathBuf};
use tempdir::TempDir;

pub struct Package {
    pub name: String,
    pub has_version: bool,
    pub version: String,
}

pub fn pack(file: &str, version: &str) -> io::Result<Package> {
    // Check that the file exists...
    if !Path::new(file).exists() {
        return Err(
            io::Error::new(
                io::ErrorKind::NotFound,
                format!("Unable to find file {} - are you sure it exists?", file)
            )
        );
    }

    let contents = fs::read_to_string(file).unwrap();
    let packfile: serde_yaml::Value = serde_yaml::from_str(&contents).unwrap();

    let has_version: bool = !version.trim().is_empty();
    let has_commands: bool = packfile["commands"].is_sequence();
    let commands = parse_commands(packfile["commands"].as_sequence());

    let tmp_dir = copy_to_temp_dir()?;

    // Check if we have any commands and run them
    if has_commands {
        run_commands(tmp_dir, commands)?;
    }

    let package = Package {
        name: String::from(packfile["package-as"].as_str().unwrap()),
        has_version: has_version,
        version: String::from(version),
    };

    return Ok(package);
}

// Create and copy to a temporary directory before doing anything
// with the files.
fn copy_to_temp_dir() -> io::Result<PathBuf> {
    let tmp_dir = TempDir::new("packmule")?;

    // Copy files from source directory

    return Ok(tmp_dir.path().to_owned());
}

fn run_commands(tmp_dir: PathBuf, commands: Vec<String>) -> io::Result<()> {
    return Ok(());
}

fn parse_commands(commands: Option<&Vec<serde_yaml::Value>>) -> Vec<String> {
    let mut command_vector = Vec::new();

    for command in commands.unwrap() {
        command_vector.push(
            String::from(command.as_str().unwrap())
        );
    }

    return command_vector;
}

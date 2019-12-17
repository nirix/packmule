extern crate serde_yaml;
extern crate tempdir;
extern crate walkdir;
extern crate glob;
extern crate tar;

use std::env;
use std::io;
use std::fs;
// use std::fmt;
use std::path::{Path, PathBuf};
use tempdir::TempDir;
use walkdir::{DirEntry, WalkDir};
use glob::Pattern;

pub struct Package {
    pub name: String,
    pub has_version: bool,
    pub version: String,
}

pub fn pack(file: &str, version: &str, input_dir: &str, output_dir: &str) -> io::Result<Package> {
    let packfile_path = Path::new(file);
    let packfile_abs_path = fs::canonicalize(&packfile_path).unwrap();

    // Set project directory to same directory as the Packfile if no input_dir was specified
    let source_path: PathBuf;
    let source_dir: String;
    if input_dir.trim().is_empty() {
        source_path = packfile_abs_path.parent().unwrap().to_path_buf();
    } else {
        source_path = Path::new(input_dir).canonicalize().unwrap().to_path_buf();
    }

    source_dir = String::from(
        source_path.to_str().unwrap()
    );

    // Set archive/pkg directory to the project directory if no output_dir was specified
    let archive_path: PathBuf;
    let archive_dir: String;
    if input_dir.trim().is_empty() {
        let mut pkg_path = packfile_abs_path.parent().unwrap().to_owned();
        pkg_path.push("pkg");
        archive_path = pkg_path.to_path_buf();
        drop(pkg_path);
    } else {
        archive_path = Path::new(output_dir).canonicalize().unwrap().to_path_buf();
    }

    archive_dir = String::from(
        archive_path.to_str().unwrap()
    );

    // Set the process directory to the projects directory
    env::set_current_dir(&source_path)?;

    // Check that the file exists...
    if !packfile_abs_path.exists() {
        return Err(
            io::Error::new(
                io::ErrorKind::NotFound,
                format!("Unable to find file {} - are you sure it exists?", file)
            )
        );
    }

    // Get config from Packfile
    let contents = fs::read_to_string(packfile_abs_path).unwrap();
    let packfile: serde_yaml::Value = serde_yaml::from_str(&contents).unwrap();

    let has_version: bool = !version.trim().is_empty();
    let has_commands: bool = packfile["commands"].is_sequence();
    // let has_ignored_files: bool = packfile["ignore"].is_sequence();
    let commands = parse_collection(packfile["commands"].as_sequence());
    let mut ignored_files = parse_collection(packfile["ignore"].as_sequence());
    ignored_files.push(String::from("Packfile"));

    // Copy to temp dir and run everything there
    let tmp_dir: TempDir = copy_to_temp_dir(&source_path, &ignored_files)?;

    // Check if we have any commands and run them
    if has_commands {
        run_commands(&tmp_dir, commands)?;
    }

    // Create a package object containing package info and created archives
    let package = Package {
        name: String::from(packfile["package-as"].as_str().unwrap()),
        has_version: has_version,
        version: String::from(version),
    };

    return Ok(package);
}

// Create and copy to a temporary directory before doing anything
// with the files.
fn copy_to_temp_dir(source_dir: &PathBuf, ignored_files: &Vec<String>) -> io::Result<TempDir> {
    let tmp_dir = TempDir::new("packmule")?;
    let source_dir_str = source_dir.to_str().unwrap();

    // Copy files from source directory
    let walker = WalkDir::new(source_dir).follow_links(true);
    let dir_iter = walker.into_iter();
    let tmp_dir_path = tmp_dir.path().to_str().unwrap();
    println!("{}", tmp_dir_path);
    for entry in dir_iter.filter_entry(|e| filter_files(e, &source_dir_str, &ignored_files)) {
        let entry = entry.unwrap();

        // let file_name = entry.file_name().to_str().unwrap();
        let source_path = format!("{}/", &source_dir.to_str().unwrap());
        let relative_path = entry.path().to_str().unwrap().replace(&source_path, "");

        // Skip if entry _is_ the source directory
        if &relative_path == &source_dir_str {
            continue;
        }

        // Create directory, don't copy, we don't want to accidentally copy ignored files
        if entry.path().is_dir() {
            fs::create_dir_all(format!("{}/{}", tmp_dir_path, relative_path))?;
        } else {
            fs::copy(entry.path(), format!("{}/{}", tmp_dir_path, relative_path))?;
        }
    }

    return Ok(tmp_dir);
}

// TODO: Find a way to not re-create glob::Patern's for every file.
fn filter_files(entry: &DirEntry, source_dir: &str, ignored_files: &Vec<String>) -> bool {
    let source_path = format!("{}/", source_dir);
    let relative_path = entry.path().to_str().unwrap().replace(&source_path, "");

    for ignored in ignored_files {
        let ignored_pattern = format!("*{}", ignored);
        let pattern = Pattern::new(&ignored_pattern).unwrap();

        if entry.path().is_dir() {
            // Append slash to end of directories when matching
            let dir_name = format!("{}/", &relative_path);

            if pattern.matches(&dir_name) {
                return false;
            }
        } else {
            if pattern.matches(&relative_path) {
                return false;
            }
        }
    }

    return true;
}

fn run_commands(tmp_dir: &TempDir, commands: Vec<String>) -> io::Result<()> {
    return Ok(());
}

fn parse_collection(values: Option<&Vec<serde_yaml::Value>>) -> Vec<String> {
    let mut vector = Vec::new();

    for value in values.unwrap() {
        vector.push(
            String::from(value.as_str().unwrap())
        );
    }

    return vector;
}

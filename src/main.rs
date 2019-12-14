extern crate clap;

use std::io;
use clap::{Arg, App, SubCommand};
use packer::Package;

const PACKMULE_VERSION: &str = "0.8.0";

mod packer;

fn main() {
    let app = App::new("Packmule")
        .version(PACKMULE_VERSION)
        .author("Jack Polgar <jack@polgar.id.au")
        .about("Project packaging made easy")
        .subcommand(
            SubCommand::with_name("pack")
                .about("Execute a Packfile")
                .arg(
                    Arg::with_name("FILE")
                        .short("f")
                        .long("file")
                        .default_value("Packfile")
                        .help("Path to Packfile")
                )
                .arg(
                    Arg::with_name("VERSION")
                       .short("v")
                       .long("version")
                       .takes_value(true)
                       .help("Version to package as, e.g. 1.2.3")
                )
        );

    let matches = app.get_matches();

    if let Some(pack_opts) = matches.subcommand_matches("pack") {
        let result: io::Result<Package> = packer::pack(
            pack_opts.value_of("FILE").unwrap_or_default(),
            pack_opts.value_of("VERSION").unwrap_or_default()
        );

        if result.is_err() {
            std::process::exit(1)
        }

        match result {
            Ok(v) => package_created(v),
            Err(e) => println!("Error: {}", e),
        }
    }
}

fn package_created(package: Package) {
    if package.has_version {
        println!("{} packaged as {}", package.name, package.version);
    } else {
        println!("Packaged as {}", package.name);
    }
}
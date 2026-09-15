use manifest_core::Checker;
use std::{env, fs, process::ExitCode};
use tracing::{info, warn};

const CARRIER_HOSTS: &[&str] = &["track.example-carrier.com", "parcels.example.net", "ship.example.org"];

fn main() -> ExitCode {
    tracing_subscriber::fmt()
        .with_env_filter(tracing_subscriber::EnvFilter::from_default_env())
        .with_writer(std::io::stderr)
        .init();

    let Some(path) = env::args().nth(1) else {
        eprintln!("usage: manifest-check <manifest.csv>");
        return ExitCode::from(2);
    };
    let manifest = match fs::read_to_string(&path) {
        Ok(text) => text,
        Err(error) => {
            eprintln!("cannot read {path}: {error}");
            return ExitCode::from(2);
        }
    };

    let report = Checker::new(CARRIER_HOSTS).check(&manifest);
    for error in &report.errors {
        warn!(%error, "rejected line");
    }
    info!(shipments = report.shipments.len(), errors = report.errors.len(), "checked {path}");
    println!("{}", serde_json::to_string_pretty(&report).expect("report serializes"));
    if report.errors.is_empty() { ExitCode::SUCCESS } else { ExitCode::FAILURE }
}

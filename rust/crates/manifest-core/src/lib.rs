//! Parses and checks carrier shipping manifests (one shipment per line).
//!
//! A line is `shipment_id,tracking_url,contact_email,shipped_at`, where
//! `shipped_at` is `YYYY-MM-DD HH:MM` in the warehouse's local time.

use chrono::NaiveDateTime;
use regex::Regex;
use serde::Serialize;
use std::fmt;
use url::Url;

const SHIPPED_AT_FORMAT: &str = "%Y-%m-%d %H:%M";

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct Shipment {
    pub id: String,
    pub tracking_host: String,
    pub contact_email: String,
    pub shipped_at: NaiveDateTime,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct LineError {
    pub line: usize,
    pub reason: String,
}

impl fmt::Display for LineError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "line {}: {}", self.line, self.reason)
    }
}

#[derive(Debug, Default, Serialize)]
pub struct Report {
    pub shipments: Vec<Shipment>,
    pub errors: Vec<LineError>,
}

pub struct Checker {
    id_pattern: Regex,
    email_pattern: Regex,
    allowed_hosts: Vec<String>,
}

impl Checker {
    pub fn new(allowed_hosts: &[&str]) -> Self {
        Checker {
            id_pattern: Regex::new(r"^SHP-[0-9]{6,10}$").expect("valid id pattern"),
            email_pattern: Regex::new(r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$").expect("valid email pattern"),
            allowed_hosts: allowed_hosts.iter().map(|h| h.to_ascii_lowercase()).collect(),
        }
    }

    pub fn check(&self, manifest: &str) -> Report {
        let mut report = Report::default();
        for (index, raw) in manifest.lines().enumerate() {
            let line = index + 1;
            let trimmed = raw.trim();
            if trimmed.is_empty() || trimmed.starts_with('#') {
                continue;
            }
            match self.parse_line(trimmed) {
                Ok(shipment) => report.shipments.push(shipment),
                Err(reason) => report.errors.push(LineError { line, reason }),
            }
        }
        report
    }

    fn parse_line(&self, line: &str) -> Result<Shipment, String> {
        let fields: Vec<&str> = line.split(',').map(str::trim).collect();
        if fields.len() != 4 {
            return Err(format!("expected 4 fields, found {}", fields.len()));
        }
        let id = fields[0];
        if !self.id_pattern.is_match(id) {
            return Err(format!("bad shipment id {id:?}"));
        }
        let url = Url::parse(fields[1]).map_err(|e| format!("bad tracking url: {e}"))?;
        if url.scheme() != "https" {
            return Err("tracking url must use https".to_string());
        }
        let host = url.host_str().unwrap_or_default().to_ascii_lowercase();
        if !self.allowed_hosts.iter().any(|allowed| host == *allowed || host.ends_with(&format!(".{allowed}"))) {
            return Err(format!("tracking host {host} is not a known carrier"));
        }
        let email = fields[2];
        if !self.email_pattern.is_match(email) {
            return Err(format!("bad contact email {email:?}"));
        }
        let shipped_at = NaiveDateTime::parse_from_str(fields[3], SHIPPED_AT_FORMAT)
            .map_err(|e| format!("bad shipped_at: {e}"))?;
        Ok(Shipment { id: id.to_string(), tracking_host: host, contact_email: email.to_string(), shipped_at })
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn checker() -> Checker {
        Checker::new(&["track.example-carrier.com", "parcels.example.net"])
    }

    #[test]
    fn accepts_a_good_line() {
        let report = checker().check("SHP-0012345,https://track.example-carrier.com/t/0012345,ops@example.com,2024-03-01 09:30\n");
        assert!(report.errors.is_empty(), "{:?}", report.errors);
        assert_eq!(report.shipments.len(), 1);
        assert_eq!(report.shipments[0].tracking_host, "track.example-carrier.com");
    }

    #[test]
    fn skips_comments_and_blank_lines() {
        let report = checker().check("# carrier export\n\nSHP-0000001,https://parcels.example.net/x,a@b.io,2024-01-02 00:00\n");
        assert_eq!(report.shipments.len(), 1);
    }

    #[test]
    fn reports_each_bad_field() {
        let manifest = [
            "SHP-12,https://parcels.example.net/x,a@b.io,2024-01-02 00:00",
            "SHP-0000002,http://parcels.example.net/x,a@b.io,2024-01-02 00:00",
            "SHP-0000003,https://evil.example.org/x,a@b.io,2024-01-02 00:00",
            "SHP-0000004,https://parcels.example.net/x,not-an-email,2024-01-02 00:00",
            "SHP-0000005,https://parcels.example.net/x,a@b.io,yesterday",
        ]
        .join("\n");
        let report = checker().check(&manifest);
        let lines: Vec<usize> = report.errors.iter().map(|e| e.line).collect();
        assert_eq!(lines, vec![1, 2, 3, 4, 5]);
    }
}

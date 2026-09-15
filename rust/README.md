# manifest-tools

Checks the shipping manifests carriers send us before they go into the ledger.

    cargo run -p manifest-cli -- samples/manifest.csv

`manifest-core` holds the parser and the checks; `manifest-cli` is the `manifest-check` binary the
nightly import runs. The toolchain is pinned in `rust-toolchain.toml`.

    cargo build --locked
    cargo test --locked

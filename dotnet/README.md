# Ledger

The billing ledger behind the customer portal (`src/Ledger.Api`), its domain library
(`src/Ledger.Core`), and the nightly report worker (`reports-worker`, built separately: it needs
the internal feed).

    dotnet restore Ledger.sln
    dotnet build Ledger.sln --no-restore
    dotnet test Ledger.sln --no-build

`Ledger.Api` keeps a NuGet lock file; CI restores it in locked mode.

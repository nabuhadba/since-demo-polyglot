# reports-worker

Nightly receivables report for finance. Restores `Fleetwise.Reporting.Client` from the internal
feed (`nuget.config`), so it builds only on machines with feed credentials. Not part of
`Ledger.sln`.

    dotnet build ReportsWorker.csproj

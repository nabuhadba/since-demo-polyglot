# billing-export

Nightly export of the day's invoices to the accounting system's CSV import.

    mvn -B verify
    java -cp export-cli/target/export-cli-1.8.0-SNAPSHOT.jar com.fleetwise.billing.cli.ExportMain 2024-03-01

Versions live in the parent `pom.xml` properties, except where a module overrides them.
The export box runs the `Dockerfile` image from cron.

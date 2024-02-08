package com.fleetwise.billing.cli;

import com.fleetwise.billing.export.CsvExporter;
import com.fleetwise.billing.export.InvoiceSource;
import java.io.File;
import java.time.LocalDate;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public final class ExportMain {
    private static final Logger LOG = LogManager.getLogger(ExportMain.class);

    private ExportMain() {}

    public static void main(String[] args) throws Exception {
        LocalDate day = args.length > 0 ? LocalDate.parse(args[0]) : LocalDate.now().minusDays(1);
        String jdbcUrl = System.getenv().getOrDefault("BILLING_JDBC_URL", "jdbc:postgresql://localhost:5432/billing");
        File target = new File(System.getenv().getOrDefault("EXPORT_DIR", "out"), "invoices-" + day + ".csv");
        LOG.info("exporting invoices issued on {}", day);
        new CsvExporter().write(new InvoiceSource(jdbcUrl).issuedOn(day), target);
    }
}

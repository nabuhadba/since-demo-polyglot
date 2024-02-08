package com.fleetwise.billing.export;

import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.util.List;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/** Writes the accounting system's import file. Column order is fixed by the accounting system. */
public final class CsvExporter {
    private static final Logger LOG = LogManager.getLogger(CsvExporter.class);
    private static final String[] HEADER = {"invoice_number", "customer", "issued_on", "total"};

    public String toCsv(List<InvoiceRow> rows) throws IOException {
        StringWriter out = new StringWriter();
        try (CSVPrinter printer = new CSVPrinter(out, CSVFormat.DEFAULT.builder().setHeader(HEADER).build())) {
            for (InvoiceRow row : rows) {
                printer.printRecord(row.number(), row.customer(), row.issuedOn(), row.total().toPlainString());
            }
        }
        return out.toString();
    }

    public void write(List<InvoiceRow> rows, File target) throws IOException {
        FileUtils.writeStringToFile(target, toCsv(rows), StandardCharsets.UTF_8);
        LOG.info("wrote {} invoices to {}", rows.size(), target);
    }
}

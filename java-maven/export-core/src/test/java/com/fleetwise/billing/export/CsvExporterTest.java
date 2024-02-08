package com.fleetwise.billing.export;

import static org.junit.Assert.assertEquals;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Arrays;
import org.junit.Test;

public class CsvExporterTest {
    @Test
    public void writesHeaderAndRowsInTheAccountingOrder() throws Exception {
        String csv = new CsvExporter().toCsv(Arrays.asList(
                new InvoiceRow("INV-1", "Acme Freight", LocalDate.of(2024, 3, 1), new BigDecimal("649.50")),
                new InvoiceRow("INV-2", "Smith, Jones & Co", LocalDate.of(2024, 3, 1), new BigDecimal("12.00"))));

        assertEquals("invoice_number,customer,issued_on,total\r\n"
                + "INV-1,Acme Freight,2024-03-01,649.50\r\n"
                + "INV-2,\"Smith, Jones & Co\",2024-03-01,12.00\r\n", csv);
    }
}

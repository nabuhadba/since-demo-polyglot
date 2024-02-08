package com.fleetwise.billing.export;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public final class InvoiceSource {
    private final String jdbcUrl;

    public InvoiceSource(String jdbcUrl) {
        this.jdbcUrl = jdbcUrl;
    }

    public List<InvoiceRow> issuedOn(LocalDate day) throws SQLException {
        List<InvoiceRow> rows = new ArrayList<>();
        try (Connection connection = DriverManager.getConnection(jdbcUrl);
             PreparedStatement statement = connection.prepareStatement(
                     "select number, customer, issued_on, total from invoice where issued_on = ? order by number")) {
            statement.setObject(1, day);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    rows.add(new InvoiceRow(result.getString(1), result.getString(2),
                            result.getObject(3, LocalDate.class), result.getBigDecimal(4)));
                }
            }
        }
        return rows;
    }
}

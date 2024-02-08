package com.fleetwise.billing.export;

import java.math.BigDecimal;
import java.time.LocalDate;

public final class InvoiceRow {
    private final String number;
    private final String customer;
    private final LocalDate issuedOn;
    private final BigDecimal total;

    public InvoiceRow(String number, String customer, LocalDate issuedOn, BigDecimal total) {
        this.number = number;
        this.customer = customer;
        this.issuedOn = issuedOn;
        this.total = total;
    }

    public String number() { return number; }
    public String customer() { return customer; }
    public LocalDate issuedOn() { return issuedOn; }
    public BigDecimal total() { return total; }
}

package com.fleetwise.inventory;

import java.util.List;

public final class App {
    private App() {}

    public static void main(String[] args) throws Exception {
        var config = ConfigLoader.load(App.class.getResourceAsStream("/warehouses.yml"));
        System.err.println("warehouses: " + config.warehouses.size());
        var levels = List.of(
                new StockLevel("PAL-48", "DEN", 12, 20),
                new StockLevel("WRP-80", "DEN", 140, 50),
                new StockLevel("PAL-48", "CHI", 3, 20));
        System.err.println(ReorderReport.subjectLine("Reorder report: ${count} SKUs", ReorderReport.byWarehouse(levels).size()));
        System.out.println(ReorderReport.toJson(levels));
    }
}

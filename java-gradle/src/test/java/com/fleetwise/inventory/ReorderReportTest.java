package com.fleetwise.inventory;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.List;
import org.junit.jupiter.api.Test;

class ReorderReportTest {
    private final List<StockLevel> levels = List.of(
            new StockLevel("PAL-48", "DEN", 12, 20),
            new StockLevel("WRP-80", "DEN", 140, 50),
            new StockLevel("PAL-48", "CHI", 3, 20));

    @Test
    void groupsOnlyWhatNeedsReordering() {
        var grouped = ReorderReport.byWarehouse(levels);
        assertEquals(List.of("PAL-48"), grouped.get("DEN").stream().map(StockLevel::sku).toList());
        assertEquals(2, grouped.size());
    }

    @Test
    void jsonListsSkusPerWarehouse() throws Exception {
        assertTrue(ReorderReport.toJson(levels).contains("\"CHI\" : [ \"PAL-48\" ]"));
    }

    @Test
    void subjectLineFillsTheCount() {
        assertEquals("Reorder report: 2 SKUs", ReorderReport.subjectLine("Reorder report: ${count} SKUs", 2));
    }
}

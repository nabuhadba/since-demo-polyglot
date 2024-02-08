package com.fleetwise.inventory;

public record StockLevel(String sku, String warehouse, int onHand, int reorderAt) {
    public boolean needsReorder() {
        return onHand <= reorderAt;
    }
}

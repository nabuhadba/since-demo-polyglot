package com.fleetwise.inventory;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class ConfigLoaderTest {
    @Test
    void readsTheWarehouses() {
        var config = ConfigLoader.load(getClass().getResourceAsStream("/warehouses.yml"));
        assertEquals(2, config.warehouses.size());
        assertEquals(24, config.warehouses.get(0).dockDoors);
    }
}

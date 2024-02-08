package com.fleetwise.inventory;

import java.util.List;

/** Mirrors warehouses.yml. Public fields so SnakeYAML can fill them. */
public class WarehouseConfig {
    public List<Warehouse> warehouses;

    public static class Warehouse {
        public String code;
        public String name;
        public int dockDoors;
    }
}

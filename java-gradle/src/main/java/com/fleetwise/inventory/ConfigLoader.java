package com.fleetwise.inventory;

import java.io.InputStream;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.Constructor;

public final class ConfigLoader {
    private ConfigLoader() {}

    public static WarehouseConfig load(InputStream yaml) {
        return new Yaml(new Constructor(WarehouseConfig.class)).load(yaml);
    }
}

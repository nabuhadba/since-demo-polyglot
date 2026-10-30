package com.fleetwise.inventory;

import java.io.InputStream;
import org.yaml.snakeyaml.LoaderOptions;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.Constructor;

public final class ConfigLoader {
    private ConfigLoader() {}

    public static WarehouseConfig load(InputStream yaml) {
        return new Yaml(new Constructor(WarehouseConfig.class, new LoaderOptions())).load(yaml);
    }
}

package com.fleetwise.inventory;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.google.common.collect.ImmutableListMultimap;
import com.google.common.collect.Multimaps;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.text.StringSubstitutor;

/** The morning reorder report: what to reorder, grouped by warehouse, as JSON for the buyers' sheet. */
public final class ReorderReport {
    private static final ObjectMapper JSON = new ObjectMapper().enable(SerializationFeature.INDENT_OUTPUT);

    private ReorderReport() {}

    public static ImmutableListMultimap<String, StockLevel> byWarehouse(List<StockLevel> levels) {
        return Multimaps.index(levels.stream().filter(StockLevel::needsReorder).iterator(), StockLevel::warehouse);
    }

    public static String toJson(List<StockLevel> levels) throws Exception {
        Map<String, List<String>> grouped = byWarehouse(levels).asMap().entrySet().stream()
                .collect(Collectors.toMap(Map.Entry::getKey, e -> e.getValue().stream().map(StockLevel::sku).toList()));
        return JSON.writeValueAsString(grouped);
    }

    public static String subjectLine(String template, int count) {
        return new StringSubstitutor(Map.of("count", count)).replace(template);
    }
}

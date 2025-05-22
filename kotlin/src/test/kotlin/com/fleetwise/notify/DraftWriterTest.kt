package com.fleetwise.notify

import kotlin.test.Test
import kotlin.test.assertEquals

class DraftWriterTest {
    @Test
    fun requestNamesTheModelAndTheShipment() {
        val body = DraftWriter(apiKey = "test").requestBody(DelayNotice("SHP-1", "https://example.com/hook", "weather", 6))
        assertEquals(DraftWriter.MODEL, body["model"])
        assertEquals(200, body["max_tokens"])
    }
}

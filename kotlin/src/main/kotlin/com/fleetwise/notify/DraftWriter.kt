package com.fleetwise.notify

import com.fasterxml.jackson.databind.ObjectMapper
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody

/** Writes the customer-facing delay message. Ops can turn it off and send the template instead. */
class DraftWriter(
    private val http: OkHttpClient = OkHttpClient(),
    private val json: ObjectMapper = ObjectMapper(),
    private val apiKey: String = System.getenv("ANTHROPIC_API_KEY").orEmpty(),
) {
    fun requestBody(notice: DelayNotice): Map<String, Any> = mapOf(
        "model" to MODEL,
        "max_tokens" to 200,
        "temperature" to 0.4,
        "messages" to listOf(
            mapOf("role" to "user", "content" to "Write a two-sentence delay notice. Shipment ${notice.shipmentId}, ${notice.hoursLate}h late: ${notice.reason}"),
        ),
    )

    fun delayMessage(notice: DelayNotice): String {
        val request = Request.Builder()
            .url("https://api.anthropic.com/v1/messages")
            .header("x-api-key", apiKey)
            .header("anthropic-version", "2023-06-01")
            .post(json.writeValueAsString(requestBody(notice)).toRequestBody("application/json".toMediaType()))
            .build()
        http.newCall(request).execute().use { response ->
            val body = json.readTree(response.body?.string().orEmpty())
            return body.path("content").path(0).path("text").asText(template(notice)).trim()
        }
    }

    private fun template(notice: DelayNotice) =
        "Shipment ${notice.shipmentId} is running about ${notice.hoursLate} hours late (${notice.reason}). We will update you when it moves."

    companion object {
        const val MODEL = "claude-sonnet-5-5"
    }
}

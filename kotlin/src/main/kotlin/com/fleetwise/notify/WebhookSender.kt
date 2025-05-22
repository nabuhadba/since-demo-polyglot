package com.fleetwise.notify

import com.fasterxml.jackson.databind.ObjectMapper
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import java.util.concurrent.TimeUnit

class WebhookSender(
    private val http: OkHttpClient = OkHttpClient.Builder().callTimeout(10, TimeUnit.SECONDS).build(),
    private val json: ObjectMapper = ObjectMapper(),
) {
    fun send(url: String, payload: Map<String, Any>) {
        val request = Request.Builder()
            .url(url)
            .post(json.writeValueAsString(payload).toRequestBody("application/json".toMediaType()))
            .build()
        http.newCall(request).execute().use { response ->
            check(response.isSuccessful) { "webhook $url answered ${response.code}" }
        }
    }
}

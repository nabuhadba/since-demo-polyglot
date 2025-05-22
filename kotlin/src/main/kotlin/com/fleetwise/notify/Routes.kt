package com.fleetwise.notify

import io.ktor.http.HttpStatusCode
import io.ktor.server.application.Application
import io.ktor.server.application.call
import io.ktor.server.request.receive
import io.ktor.server.response.respond
import io.ktor.server.routing.post
import io.ktor.server.routing.routing

data class DelayNotice(val shipmentId: String, val customerWebhook: String, val reason: String, val hoursLate: Int)

fun Application.notifyRoutes(webhooks: WebhookSender, drafts: DraftWriter) {
    routing {
        post("/notices/delay") {
            val notice = call.receive<DelayNotice>()
            val message = drafts.delayMessage(notice)
            webhooks.send(notice.customerWebhook, mapOf("shipment" to notice.shipmentId, "message" to message))
            call.respond(HttpStatusCode.Accepted, mapOf("queued" to notice.shipmentId))
        }
    }
}

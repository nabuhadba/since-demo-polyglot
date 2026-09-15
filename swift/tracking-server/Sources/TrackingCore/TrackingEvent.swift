import Foundation

/// A scan from a carrier's tracking feed: `SHP-0012345|2024-03-01T09:30:00Z|DEN|out_for_delivery`.
public struct TrackingEvent: Codable, Equatable {
    public enum Status: String, Codable {
        case pickedUp = "picked_up"
        case inTransit = "in_transit"
        case outForDelivery = "out_for_delivery"
        case delivered
        case exception
    }

    public let shipmentID: String
    public let scannedAt: Date
    public let facility: String
    public let status: Status

    public init(shipmentID: String, scannedAt: Date, facility: String, status: Status) {
        self.shipmentID = shipmentID
        self.scannedAt = scannedAt
        self.facility = facility
        self.status = status
    }

    public static func parse(_ line: Substring) -> TrackingEvent? {
        let fields = line.split(separator: "|", omittingEmptySubsequences: false)
        guard fields.count == 4,
              fields[0].hasPrefix("SHP-"),
              let scannedAt = ISO8601DateFormatter().date(from: String(fields[1])),
              let status = Status(rawValue: String(fields[3])),
              !fields[2].isEmpty
        else { return nil }
        return TrackingEvent(shipmentID: String(fields[0]), scannedAt: scannedAt, facility: String(fields[2]), status: status)
    }
}

/// The latest event per shipment, which is what the portal shows.
public struct TrackingBoard {
    private var latest: [String: TrackingEvent] = [:]

    public init() {}

    public mutating func ingest(_ feed: String) -> Int {
        var accepted = 0
        for line in feed.split(separator: "\n") {
            guard let event = TrackingEvent.parse(line) else { continue }
            if let current = latest[event.shipmentID], current.scannedAt > event.scannedAt { continue }
            latest[event.shipmentID] = event
            accepted += 1
        }
        return accepted
    }

    public func status(of shipmentID: String) -> TrackingEvent? {
        latest[shipmentID]
    }
}

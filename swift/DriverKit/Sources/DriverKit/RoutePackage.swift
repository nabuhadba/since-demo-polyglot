import Foundation
import ZIPFoundation

/// The offline route package a driver downloads before a shift: stops.json plus map tiles, zipped.
public struct RoutePackage {
    public struct Stop: Codable, Equatable {
        public let sequence: Int
        public let shipmentID: String
        public let address: String
    }

    public let stops: [Stop]
    public let tilesDirectory: URL

    /// Unzips a route package into `directory` and reads its stops.
    public static func unpack(_ archiveURL: URL, into directory: URL) throws -> RoutePackage {
        let fileManager = FileManager.default
        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        try fileManager.unzipItem(at: archiveURL, to: directory)
        let data = try Data(contentsOf: directory.appendingPathComponent("stops.json"))
        let stops = try JSONDecoder().decode([Stop].self, from: data).sorted { $0.sequence < $1.sequence }
        return RoutePackage(stops: stops, tilesDirectory: directory.appendingPathComponent("tiles"))
    }
}

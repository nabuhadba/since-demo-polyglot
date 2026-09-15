import XCTest
import ZIPFoundation
@testable import DriverKit

final class RoutePackageTests: XCTestCase {
    func testUnpacksStopsInSequenceOrder() throws {
        let fileManager = FileManager.default
        let work = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let source = work.appendingPathComponent("source")
        try fileManager.createDirectory(at: source.appendingPathComponent("tiles"), withIntermediateDirectories: true)
        let stops = """
        [{"sequence": 2, "shipmentID": "SHP-2", "address": "2 Elm St"}, {"sequence": 1, "shipmentID": "SHP-1", "address": "1 Oak Ave"}]
        """
        try Data(stops.utf8).write(to: source.appendingPathComponent("stops.json"))
        let archive = work.appendingPathComponent("route.zip")
        try fileManager.zipItem(at: source, to: archive, shouldKeepParent: false)

        let route = try RoutePackage.unpack(archive, into: work.appendingPathComponent("out"))
        XCTAssertEqual(route.stops.map(\.shipmentID), ["SHP-1", "SHP-2"])
    }
}

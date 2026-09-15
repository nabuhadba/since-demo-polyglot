import TrackingCore
import XCTest

final class TrackingBoardTests: XCTestCase {
    func testKeepsTheLatestScanPerShipment() {
        var board = TrackingBoard()
        let accepted = board.ingest("""
        SHP-0012345|2024-03-01T09:30:00Z|CHI|picked_up
        SHP-0012345|2024-03-02T14:05:00Z|DEN|out_for_delivery
        SHP-0012345|2024-03-01T23:00:00Z|OMA|in_transit
        """)
        XCTAssertEqual(accepted, 2)
        XCTAssertEqual(board.status(of: "SHP-0012345")?.facility, "DEN")
    }

    func testSkipsMalformedLines() {
        var board = TrackingBoard()
        XCTAssertEqual(board.ingest("garbage\nSHP-1|not-a-date|DEN|delivered\nSHP-2|2024-03-01T09:30:00Z|DEN|lost\n"), 0)
    }
}

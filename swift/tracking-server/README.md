# tracking-server

Serves the latest carrier scan per shipment to the customer portal. SwiftNIO, runs on Linux in production.

    swift build
    swift test
    swift run tracking-server samples/feed.txt

import Foundation
import NIOCore
import NIOHTTP1
import NIOPosix
import TrackingCore

final class TrackingHandler: ChannelInboundHandler {
    typealias InboundIn = HTTPServerRequestPart
    typealias OutboundOut = HTTPServerResponsePart

    private let board: TrackingBoard
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    init(board: TrackingBoard) {
        self.board = board
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        guard case .head(let request) = unwrapInboundIn(data) else { return }
        let id = request.uri.split(separator: "/").last.map(String.init) ?? ""
        let (status, body): (HTTPResponseStatus, Data) =
            if let event = board.status(of: id), let json = try? encoder.encode(event) {
                (.ok, json)
            } else {
                (.notFound, Data("{\"error\":\"unknown shipment\"}".utf8))
            }

        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/json")
        headers.add(name: "Content-Length", value: String(body.count))
        context.write(wrapOutboundOut(.head(HTTPResponseHead(version: request.version, status: status, headers: headers))), promise: nil)
        var buffer = context.channel.allocator.buffer(capacity: body.count)
        buffer.writeBytes(body)
        context.write(wrapOutboundOut(.body(.byteBuffer(buffer))), promise: nil)
        context.writeAndFlush(wrapOutboundOut(.end(nil)), promise: nil)
    }
}

var board = TrackingBoard()
if let path = CommandLine.arguments.dropFirst().first, let feed = try? String(contentsOfFile: path, encoding: .utf8) {
    print("loaded \(board.ingest(feed)) tracking events from \(path)")
}
let snapshot = board

let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
let bootstrap = ServerBootstrap(group: group)
    .serverChannelOption(ChannelOptions.backlog, value: 256)
    .serverChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
    .childChannelInitializer { channel in
        channel.pipeline.configureHTTPServerPipeline().flatMap {
            channel.pipeline.addHandler(TrackingHandler(board: snapshot))
        }
    }

let port = Int(ProcessInfo.processInfo.environment["PORT"] ?? "8080") ?? 8080
let channel = try bootstrap.bind(host: "0.0.0.0", port: port).wait()
print("tracking-server listening on \(port)")
try channel.closeFuture.wait()

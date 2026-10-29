import Foundation

/// Turns a customer's delivery note into one short line for the stop card.
/// The request goes through our gateway, which holds the OpenAI key; the app never sees it.
public struct StopNotes {
    public static let model = "gpt-5.6-sol"

    let gateway: URL
    let session: URLSession

    public init(gateway: URL, session: URLSession = .shared) {
        self.gateway = gateway
        self.session = session
    }

    public func shorten(_ note: String) async throws -> String {
        var request = URLRequest(url: gateway.appendingPathComponent("v1/chat/completions"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "model": Self.model,
            "max_tokens": 60,
            "messages": [
                ["role": "system", "content": "Rewrite delivery notes as one short line for a driver."],
                ["role": "user", "content": note],
            ],
        ])
        let (data, _) = try await session.data(for: request)
        let reply = try JSONDecoder().decode(Reply.self, from: data)
        return reply.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines) ?? note
    }

    struct Reply: Decodable {
        struct Choice: Decodable {
            struct Message: Decodable { let content: String }
            let message: Message
        }
        let choices: [Choice]
    }
}

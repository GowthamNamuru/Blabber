//
//  BlabberModel.swift
//  Blabber
//
//  Created by Gowtham Namuru on 02/05/24.
//

import Foundation

class BlabberModel: ObservableObject {
    var userName = ""

    var urlSession = URLSession.shared

    init() {}

    /// Current live updates
    @Published var messages: [Message] = []

    @MainActor
    func chat() async throws {
        guard let query = userName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "http://localhost:8080/chat/room?\(query)") else {
            throw "Invalid Request"
        }
        
        let (stream, response) = try await liveURLSession.bytes(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "The server responded with an error."
        }

        print("Start live updates")

        try await withTaskCancellationHandler {
            try await readMessages(stream: stream)
        } onCancel: {
            print("End live updates")
            messages = []
        }
    }

    @MainActor
    private func readMessages(stream: URLSession.AsyncBytes) async throws {
        var iterator = stream.lines.makeAsyncIterator()

        guard let first = try await iterator.next() else {
            throw "No response from server"
        }

        guard let data = first.data(using: .utf8),
              let status = try? JSONDecoder().decode(ServerStatus.self, from: data) else {
            throw "Invalid response from server"
        }

        messages.append(Message(message: "\(status.activeUsers) active users"))

        for try await line in stream.lines {
          if let data = line.data(using: .utf8),
            let update = try? JSONDecoder().decode(Message.self, from: data) {
            messages.append(update)
          }
        }
    }

    func say(_ text: String, isSystemMessage: Bool = false) async throws {
        guard !text.isEmpty,
              let url = URL(string: "http://localhost:8080/chat/say") else {
            throw "Invalid Request"
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(
            Message(id: UUID(), user: isSystemMessage ? nil : userName, message: text, date: Date())
        )
        let (_, response) = try await liveURLSession.data(for: request, delegate: nil)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw "The server responded with an error."
        }
    }

    private var liveURLSession: URLSession = {
        var configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = .infinity
        return URLSession(configuration: configuration)
    }()
}

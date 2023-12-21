import Foundation

struct DummyDecodableResponse: Codable, Equatable {
    let id: String
    let date: Date
    
    static func instance() -> Self {
        DummyDecodableResponse(
            id: "1",
            date: DateFormatter.dateFormatterForTests.date(from: "22-09-1994")!
        )
    }

    func encoded() throws -> Data {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(.dateFormatterForTests)
        return try jsonEncoder.encode(self)
    }
}

extension DateFormatter {
    static let dateFormatterForTests: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
}

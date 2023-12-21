import Foundation

enum Errors: Error {
    case httpResponse
    case urlQueryMissing
    case urlMissing
    case badConnection
    case fileIsMissing
    case dataIsMissingOrInIncorrectFormat
}

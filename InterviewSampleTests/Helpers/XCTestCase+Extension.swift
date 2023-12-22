import XCTest
import Combine

extension XCTestCase {

    private static let awaitTimeout: TimeInterval = 1

    
    @discardableResult
    /// Helper method to collect all the values emmited by given publisher into array
    /// - Parameters:
    ///   - publisher: publisher to observe
    ///   - timeout: how long sho
    ///   - completeOnTimeout:
    ///   - skipInitialValue: if true skips initial value of `@Published` property
    ///   - file: no doc
    ///   - line: no doc
    ///   - externalModifications: actions that will trigger publisher updates
    /// - Returns: Array of values from given publisher
    func valuesFromPublished<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = awaitTimeout,
        completeOnTimeout: Bool = true,
        skipInitialValue: Bool = true,
        file: StaticString = #file,
        line: UInt = #line,
        externalModifications: (() -> Void)? = nil
    ) -> [T.Output] {
        var result: [SequenceElement<T.Output, T.Failure>] = []

        let expectation = expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result.append(.failure(error: error))
                case .finished:
                    result.append(.finished)
                }
                expectation.fulfill()
            },
            receiveValue: { value in
                result.append(.value(value))
            }
        )

        externalModifications?()

        if completeOnTimeout {
            DispatchQueue.main.asyncAfter(deadline: .now() + XCTestCase.awaitTimeout) {
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: timeout)

        cancellable.cancel()

        return Array(result.compactMap { $0.value }.dropFirst(skipInitialValue ? 1 : 0))
    }
}

extension XCTestCase {

    enum SequenceElement<T, E> {
        case value(_ value: T)
        case finished
        case failure(error: E)

        var value: T? {
            switch self {
            case .value(let value):
                return value
            default:
                return nil
            }
        }
    }
}

extension XCTestCase.SequenceElement: Equatable where T: Equatable, E: Equatable {

    static func == (
        lhs: XCTestCase.SequenceElement<T, E>,
        rhs: XCTestCase.SequenceElement<T, E>
    ) -> Bool {
        switch (lhs, rhs) {
        case let (.value(lhsValue), .value(rhsValue)):
            return lhsValue == rhsValue
        case (.finished, .finished):
            return true
        case let (.failure(lhsError), .failure(rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}

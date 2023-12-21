import XCTest
import Combine

extension XCTestCase {

    private static let awaitTimeout: TimeInterval = 1

    @discardableResult
    func is_awaitSequence<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = awaitTimeout,
        completeOnTimeout: Bool = true,
        file: StaticString = #file,
        line: UInt = #line,
        externalModifications: (() -> Void)? = nil
    ) -> [SequenceElement<T.Output, T.Failure>] {
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

        return result
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

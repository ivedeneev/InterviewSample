import Foundation

protocol StateType: Equatable {
    /// Allows to pack multiple properties update into the one single State update
    ///
    /// Considering that `state` is a `@Published` property:
    ///
    /// This will trigger update 2 times
    /// ```
    /// state.isLoading = false
    /// state.result = "Hello"
    /// ```
    ///
    /// This will trigger update one time
    /// ```
    ///  state.bulkUpdate { state in
    ///      state.isLoading = false
    ///      state.result = "Hello"
    ///  }
    /// ```
    mutating func bulkUpdate(_ update: (inout Self) -> Void)
}

extension StateType {
    mutating func bulkUpdate(_ update: (inout Self) -> Void) {
        var value = self
        update(&value)
        self = value
    }
}

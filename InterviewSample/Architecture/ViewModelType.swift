import SwiftUI

protocol ViewModelType: ObservableObject {
    associatedtype Action
    associatedtype State
    
    var state: State { get }
    
    func sendAction(_ action: Action)
}

extension ViewModelType {

    /// Creates a binding which gives views access to viewmodel's state and allows to modify it via sending actions
    ///
    /// Typical usage:
    /// ```
    /// TextField(
    ///   "Placeholder",
    ///   text: viewModel.binding(
    ///     get: \.text,
    ///     action: { .textChanged($0) }
    ///   )
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - get: Closure which returns value for the binding. Typically we use keypath of the state here (see example above)
    ///   - action: Action to send when view updates value of the binding.
    /// - Returns: Binding for views to access viewmodel's state without modifying it
    func binding<V>(get: @escaping (State) -> V, action: ((V) -> Action)? = nil) -> Binding<V> {
        return Binding(
            get: { [unowned self] in
                get(self.state)
            },
            set: { [unowned self] in
                guard let action = action?($0) else { return }
                self.sendAction(action)
            }
        )
    }
}

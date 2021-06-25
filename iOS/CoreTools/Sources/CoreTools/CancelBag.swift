import Combine

public typealias CancelBag = Set<AnyCancellable>

public extension CancelBag {
    mutating func collect(@Builder _ cancellables: () -> [AnyCancellable]) {
        formUnion(cancellables())
    }

    @_functionBuilder
    struct Builder {
        static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
            return cancellables
        }
    }
}

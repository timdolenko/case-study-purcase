import Combine

public typealias CancelBag = Set<AnyCancellable>

public extension CancelBag {
    mutating func collect(@Builder _ cancellables: () -> [AnyCancellable]) {
        formUnion(cancellables())
    }

    @resultBuilder
    struct Builder {
        public static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
            return cancellables
        }
    }
}

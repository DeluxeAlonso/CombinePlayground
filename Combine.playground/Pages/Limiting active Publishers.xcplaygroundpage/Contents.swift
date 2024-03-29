import Combine

[1, 2, 3].publisher
    .print()
    .flatMap({ int in
        // flatMap takes the output of a publisher, transforms that into a new
        // publisher and all values emitted by that new publisher are passed to
        // subscribers
        return Array(repeating: int, count: 2).publisher
    })
    .sink(receiveValue: { value in
        print("got: \(value)")
    })

// MARK: - Using maxPublishers

[1, 2, 3].publisher
    .print()
    .flatMap(maxPublishers: .max(1), { int in
        // flatMap has told the upstream publisher that it only wants to receive a single value
        return Array(repeating: int, count: 2).publisher
    })
    .sink(receiveValue: { value in
        print("got - maxPublishers 1: \(value)")
    })

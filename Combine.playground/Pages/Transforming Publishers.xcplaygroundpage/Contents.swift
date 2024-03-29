import Foundation
import Combine

// MARK: - Map

[1, 2, 3].publisher
    .sink(receiveValue: { int in
        print("Current value: \(int)")
    })

[1, 2, 3].publisher
    .map({ int in
        return "Current value: \(int)"
    }) // map returns a Publishers.Sequence<[String], Never>
    .sink { string in
        print(string)
    }

// MARK: - Map and default values with replaceNil

["one", "2", "three", "4", "5"].publisher
    .map({ Int($0) })
    .replaceNil(with: 0)
    .sink(receiveValue: { int in
        print("Map with default values: \(int)") // int is an optional
    })

// MARK: - CompactMap

["one", "2", "three", "4", "5"].publisher
    .compactMap({ Int($0) })
    .sink(receiveValue: { int in
        print("Compact map: \(int)")
    })

// MARK: - Map with CompactMap

["one", "2", "three", "4", "5"].publisher
    .map({ Int($0) })
    .replaceNil(with: 0)
    .compactMap({ $0 })
    .sink(receiveValue: { int in
        print("Map with default values: \(int)") // int is NOT an optional
    })

// MARK: - FlatMap

var baseURL = URL(string: "https://www.google.com")!

["/", "/doodles"].publisher
    .map({ path in
        let url = baseURL.appendingPathComponent(path)
        return URLSession.shared.dataTaskPublisher(for: url)

        // The values that end up in the sink are not the results of the data tasks.
        // Instead, the publishers themselves are delivered to the sink.
        // Map is not useful in this scenario
    })
    .sink { completion in
        print("Completed with: \(completion)")
    } receiveValue: { result in
        print(result)
    }

var cancellables = Set<AnyCancellable>()

["/", "/doodles"].publisher
    .setFailureType(to: URLError.self)// Only needed in iOS 13
    .flatMap({ path -> URLSession.DataTaskPublisher in
        let url = baseURL.appendingPathComponent(path)
        return URLSession.shared.dataTaskPublisher(for: url)
    })
    .sink { completion in
        print("Completed with: \(completion)")
    } receiveValue: { value in
        print(value)
    }.store(in: &cancellables)

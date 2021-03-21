import Foundation
import Combine

extension Publisher where Output == String, Failure == Never {

    func mapToURLSessionDataTask(baseURL: URL) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError> {
        return self
            .setFailureType(to: URLError.self)// Only needed in iOS 13
            .flatMap({ path -> URLSession.DataTaskPublisher in
                let url = baseURL.appendingPathComponent(path)
                return URLSession.shared.dataTaskPublisher(for: url)
            })
            .eraseToAnyPublisher()
    }

}

var baseURL = URL(string: "https://www.google.com")!
var cancellables = Set<AnyCancellable>()

["/", "/doodles"].publisher
    .mapToURLSessionDataTask(baseURL: baseURL)
    .sink { completion in
        print("Completed with: \(completion)")
    } receiveValue: { value in
        print(value)
    }.store(in: &cancellables)


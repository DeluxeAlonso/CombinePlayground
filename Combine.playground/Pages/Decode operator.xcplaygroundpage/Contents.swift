import Foundation
import Combine

func fetc<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
  URLSession.shared.dataTaskPublisher(for: url)
    .map(\.data)
    .decode(type: T.self, decoder: JSONDecoder())
    .eraseToAnyPublisher()
}

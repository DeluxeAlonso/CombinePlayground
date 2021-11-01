import Combine
import Foundation

struct CustomError: Error, Decodable {}

func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
  URLSession.shared.dataTaskPublisher(for: url)
    .tryMap({ result in
      let decoder = JSONDecoder()

      guard let urlResponse = result.response as? HTTPURLResponse, (200...201).contains(urlResponse.statusCode) else {
        let error = try decoder.decode(CustomError.self, from: result.data)
        throw error
      }

      return try decoder.decode(T.self, from: result.data)
    })
    .eraseToAnyPublisher()
}

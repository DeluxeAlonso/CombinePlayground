import Combine
import Foundation

struct CustomError: Error, Decodable {}

func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
        .tryMap({ result in
            let decoder = JSONDecoder()

            // We check if status code is a success one
            guard let urlResponse = result.response as? HTTPURLResponse,
                  (200...201) ~= urlResponse.statusCode else {
                      let error = try decoder.decode(CustomError.self, from: result.data)
                      throw error
                  }

            return try decoder.decode(T.self, from: result.data)
        })
        .eraseToAnyPublisher()
}

var cancellables = Set<AnyCancellable>()
let url = URL(string: "https://www.google.com")

struct TestModel: Decodable {}

fetch(url!)
    .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion,
           let error = error as? CustomError {
            print(error)
        }
    }, receiveValue: { (model: TestModel) in
        print(model)
    }).store(in: &cancellables)

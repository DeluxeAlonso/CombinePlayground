import Foundation
import Combine

// MARK: - Non-combine approach

func fetchL<T: Decodable>(_ url: URL,
                          completion: @escaping (Result<T, Error>) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            assertionFailure("This should never happen")
            return
        }

        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedResponse))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}

// MARK: - Combine approach

func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
        .tryMap({ result in
            return try JSONDecoder().decode(T.self, from: result.data)
        })
        .eraseToAnyPublisher()
}

struct TestModel: Decodable {}

var cancellables = Set<AnyCancellable>()
let url = URL(string: "https://www.google.com")
let publisher: AnyPublisher<TestModel, Error> = fetch(url!)
    .share() // Share allows the publisher to be instantiated and only fetch once.
    .eraseToAnyPublisher()

publisher
    .sink(receiveCompletion: { completion in
        print(completion) // Should print an error
    }, receiveValue: { (model: TestModel) in
        print(model)
    }).store(in: &cancellables)

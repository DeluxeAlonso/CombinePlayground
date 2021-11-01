import Foundation
import Combine

// MARK: - Non-combine approach

func fetch<T: Decodable>(_ url: URL,
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

func fetchCombine<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
        .tryMap({ result in
            return try JSONDecoder().decode(T.self, from: result.data)
        })
        .eraseToAnyPublisher()
}

// MARK: - Combine - Decode operator approach

// Decode operator works on any publisher that has Data as its output.
func fetchCombineDecode<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: T.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
}

struct TestModel: Decodable {}

var cancellables = Set<AnyCancellable>()
let url = URL(string: "https://www.google.com")
let publisher: AnyPublisher<TestModel, Error> = fetchCombineDecode(url!)
    .share() // Share allows the publisher to be instantiated and only fetch once.
    .eraseToAnyPublisher()

publisher
    .sink(receiveCompletion: { completion in
        print(completion) // Should print an error because no valid json is received
    }, receiveValue: { (model: TestModel) in
        print(model)
    }).store(in: &cancellables)

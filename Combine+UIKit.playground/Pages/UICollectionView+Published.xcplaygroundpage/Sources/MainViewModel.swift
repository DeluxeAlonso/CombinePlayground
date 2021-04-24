import Foundation
import Combine

public enum APIError: Error {

    case notAuthenticated
    case notFound
    case networkProblem

}

public class ItemClient {

    public func getItems() -> AnyPublisher<[ItemModel], APIError> {
        Just([
            ItemModel(id: "1", title: "1", description: "1"),
            ItemModel(id: "3", title: "3", description: "3")
        ])
        .setFailureType(to: APIError.self)
        .eraseToAnyPublisher()
    }

}

public class MainViewModel {

    private let client = ItemClient()

    @Published public var items: [ItemModel] = []

    public func loadItems() {
        client.getItems().map({
            return $0
        }).catch { error -> Just<[ItemModel]> in
            return Just([])
        }.assign(to: &$items)
    }

}

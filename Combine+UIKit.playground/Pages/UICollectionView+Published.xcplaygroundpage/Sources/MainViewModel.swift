import Foundation
import Combine

public struct ItemModel: Hashable {

    public let id: String
    public let title: String
    public let description: String

    public init(id: String, title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }

}

enum APIError: Error {

    case notAuthenticated
    case notFound
    case networkProblem

}

public class ItemClient {

    func getItems() -> AnyPublisher<[ItemModel], APIError> {
        Just([
            ItemModel(id: "1", title: "1", description: "1"),
            ItemModel(id: "3", title: "3", description: "3")
        ])
        .setFailureType(to: APIError.self)
        .eraseToAnyPublisher()
    }

}

public class MainViewModel {

    let client = ItemClient()

    @Published var items: [ItemModel] = []

    public func loadItems() {
        client.getItems().map({
            return $0
        }).catch { error -> Just<[ItemModel]> in
            return Just([])
        }.assign(to: &$items)
    }

}

import UIKit
import Combine

public class MainViewModel {

    public let itemSubject = CurrentValueSubject<[ItemModel], Never>([])

    public func loadItems() {
        itemSubject.value = [
            ItemModel(id: "1", title: "1", description: "1"),
            ItemModel(id: "2", title: "2", description: "2")
        ]
    }

    public func fetchImage() -> AnyPublisher<UIImage, Never> {
        let image = UIImage(systemName: "pencil")!
        return Just(image).eraseToAnyPublisher()
    }

}

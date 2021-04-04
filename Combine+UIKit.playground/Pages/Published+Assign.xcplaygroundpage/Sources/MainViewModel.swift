import Combine

public final class MainViewModel {

    @Published public var title: String? = ""

    public func updateTitle(_ title: String) {
        self.title = "This is the new title: \(title)!"
    }

}

import Combine

class ListViewModel {

    func fetchTitle(_ title: String) -> AnyPublisher<String, Never> {
        let formattedTitle = "New title is \(title)"
        // Just is a publisher that emits an output to each
        // subscriber just once, and then finishes
        return Just(formattedTitle).eraseToAnyPublisher()
    }

}

class ListController {

    var viewModel: ListViewModel = ListViewModel()
    var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        viewModel.fetchTitle("Test").sink { titleText in
            print(titleText)
        }.store(in: &cancellables)
    }

}

let controller = ListController() // New title is Text

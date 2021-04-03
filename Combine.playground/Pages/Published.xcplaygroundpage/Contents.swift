import Combine

class ListViewModel {

    @Published var title = "Test"

    func updateTitle(_ title: String) {
        self.title = title
    }

}

class ListController {

    var viewModel: ListViewModel = ListViewModel()
    var cancellables = Set<AnyCancellable>()

    init() {
        setup()
        setupBindings()
    }

    private func setup() {
        print(viewModel.title)
    }

    private func setupBindings() {
        viewModel.$title.dropFirst().sink { titleText in
            print(titleText)
        }.store(in: &cancellables)
    }

}

let controller = ListController()
controller.viewModel.updateTitle("Test 2") // Test and Test 2 should be printed.

import Combine

struct ListViewModel {

    // CurrentValueSubject is a subject that wraps a single value
    // and publishes a new element whenever the value changes.
    var title = CurrentValueSubject<String, Never>("Test")

    func updateTitle(_ title: String) {
        self.title.value = title
    }

}

class ListController {

    var viewModel: ListViewModel = ListViewModel()
    var cancellables = Set<AnyCancellable>()

    init() {
        setup()
    }

    private func setup() {
        // CurrentValueSubject is always going to have an initial value
        print(viewModel.title)
    }

    private func setupBindings() {
        viewModel.title.sink { titleText in
            print(titleText)
        }.store(in: &cancellables)
    }

}

let controller = ListController()
controller.viewModel.updateTitle("Test 2") // Test and Test 2 should be printed.

import Combine

struct ListViewModel {

    // A subject is a publisher that exposes a method for outside callers to publish elements.
    // CurrentValueSubject is a subject that wraps a single value
    // and publishes a new element whenever the value changes.
    // Value is stored(accessed through value property) and not discarded.
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
        setupBindings()
    }

    private func setup() {
        // CurrentValueSubject is always going to have an initial value
        print(viewModel.title.value)
    }

    private func setupBindings() {
        viewModel.title.dropFirst().sink { titleText in
            print(titleText)
        }.store(in: &cancellables)
    }

}

let controller = ListController()
controller.viewModel.updateTitle("Test 2") // Test and Test 2 should be printed.

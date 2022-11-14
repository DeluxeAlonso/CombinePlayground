import Combine

class ListViewModel {

    var currentValueSubjectTitle = CurrentValueSubject<String, Never>("Initial title")

    /// Published property wrapper can only be used in classes.
    @Published var publishedTitle = "Initial title"
    
}

let viewModel = ListViewModel()

viewModel.currentValueSubjectTitle.sink(receiveValue: { value in
    print("CurrentValueSubject - Same emitted value and unerlying value? \(viewModel.currentValueSubjectTitle.value == value)")
})

viewModel.$publishedTitle.sink(receiveValue: { value in
    print("@Published - Same emitted value and unerlying value? \(viewModel.publishedTitle == value)")
})

viewModel.currentValueSubjectTitle.value = "New title"
viewModel.publishedTitle = "New title"

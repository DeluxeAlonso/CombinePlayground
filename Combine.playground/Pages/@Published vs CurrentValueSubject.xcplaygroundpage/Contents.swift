import Combine

class ListViewModel {

    var currentValueSubjectTitle = CurrentValueSubject<String, Never>("Initial title")

    /// Published property wrapper can only be used in classes.
    @Published var publishedTitle = "Initial title"
    
}

let viewModel = ListViewModel()

// CurrentValueSubject will update its value before emitting the value to its subscribers.
viewModel.currentValueSubjectTitle.sink(receiveValue: { value in
    print("CurrentValueSubject - Same emitted value and unerlying value? \(viewModel.currentValueSubjectTitle.value == value)")
})

// @Published value will update its underlying value after emitting the value to its subscribers.
viewModel.$publishedTitle.sink(receiveValue: { value in
    print("@Published - Same emitted value and unerlying value? \(viewModel.publishedTitle == value)")
})

viewModel.currentValueSubjectTitle.value = "New title"
viewModel.publishedTitle = "New title"

/*
 Output:
 CurrentValueSubject - Same emitted value and unerlying value? true
 @Published - Same emitted value and unerlying value? true
 CurrentValueSubject - Same emitted value and unerlying value? true
 @Published - Same emitted value and unerlying value? false
*/

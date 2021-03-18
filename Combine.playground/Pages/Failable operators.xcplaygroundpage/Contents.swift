import Combine

enum CustomError: Error {
    case emptyArray
}

["Test1", "", "Test2"].publisher
    .tryMap({ string in
        // After an error is thrown, the publisher can’t emit new values
        guard !string.isEmpty else { throw CustomError.emptyArray }
        return string
    })
    .sink(receiveCompletion: { completion in
        print(completion)
    }, receiveValue: { value in
        print(value)
    })

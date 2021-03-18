import Combine

enum CustomError: Error {
    case emptyArray
}

[nil, "Test1", "", "Test2"].publisher
    .compactMap { $0 }
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

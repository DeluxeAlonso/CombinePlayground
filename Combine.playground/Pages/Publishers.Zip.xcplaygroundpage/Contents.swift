import Foundation
import Combine

var cancellables = Set<AnyCancellable>()

let firstNotification = Notification(name: Notification.Name("first"))
let firstPublisher = NotificationCenter.default.publisher(for: firstNotification.name)

let secondNotification = Notification(name: Notification.Name("second"))
let secondPublisher = NotificationCenter.default.publisher(for: secondNotification.name)

// Two ways to use zip: Publishers.Zip instance and Publisher's zip instance function.
// Both have the same behavior:

let _ = Publishers.Zip(firstPublisher, secondPublisher)
    .sink { value in
        print("\(value) zipped")
    }.store(in: &cancellables)

let _ = firstPublisher.zip(secondPublisher)
    .sink { value in
        print("\(value) zipped - with Publisher's zip intance function")
    }.store(in: &cancellables)

// Zip waits for the two zipped publishers to emit values,
// otherwise it won't receive a new value

print("Post first")
NotificationCenter.default.post(firstNotification)

print("Post second")
NotificationCenter.default.post(secondNotification)

print("Post third")
NotificationCenter.default.post(firstNotification)

print("Post fourth")
NotificationCenter.default.post(secondNotification)

// MARK: - Publishers.Zip Order matching behavior

// Zip handles the emitted values in order. The first value of the first publisher
// is matched with the first value of the second publisher.

let publisherA = CurrentValueSubject<Int, Never>(0)
let publisherB = CurrentValueSubject<Int, Never>(0)

let _ = Publishers.Zip(publisherA, publisherB)
    .sink { value in
        print(value)
    }.store(in: &cancellables)

publisherA.value = 1
publisherA.value = 2
publisherA.value = 3

publisherB.value = 1
publisherB.value = 2

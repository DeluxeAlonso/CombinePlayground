import Foundation
import Combine

var cancellables = Set<AnyCancellable>()

let firstNotification = Notification(name: Notification.Name("first"))
let firstPublisher = NotificationCenter.default.publisher(for: firstNotification.name)

let secondNotification = Notification(name: Notification.Name("second"))
let secondPublisher = NotificationCenter.default.publisher(for: secondNotification.name)

// Two ways to use zip: Publishers.CombineLatest instance and Publisher's CombineLatest instance function.
// Both have the same behavior:

let _ = Publishers.CombineLatest(firstPublisher, secondPublisher)
    .sink(receiveValue: { value in
        print("\(value.0) - first publisher - combineLatest")
        print("\(value.1) - second publisher - combineLatest")
    }).store(in: &cancellables)

let _ = firstPublisher.combineLatest(secondPublisher)
    .sink { value in
        print("\(value.0) - first publisher - combineLatest - instance method")
        print("\(value.1) - second publisher - combineLatest - instance method")
    }.store(in: &cancellables)

// Emits the latest value of each publisher when one of them emits a new value.

print("Post first")
NotificationCenter.default.post(firstNotification)

print("Post second")
NotificationCenter.default.post(secondNotification)

print("Post third")
NotificationCenter.default.post(firstNotification)

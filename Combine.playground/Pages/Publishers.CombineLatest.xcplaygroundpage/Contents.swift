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
        print("\(value) combined")
    }).store(in: &cancellables)

let _ = firstPublisher.combineLatest(secondPublisher)
    .sink { value in
        print("\(value) combined - with Publisher's combineLatest intance function")
    }.store(in: &cancellables)

print("Post first")
NotificationCenter.default.post(firstNotification)

print("Post second")
NotificationCenter.default.post(secondNotification)

print("Post third")
NotificationCenter.default.post(firstNotification)

import Foundation
import Combine

var cancellables = Set<AnyCancellable>()

let firstNotification = Notification(name: Notification.Name("first"))
let firstPublisher = NotificationCenter.default.publisher(for: firstNotification.name)

let secondNotification = Notification(name: Notification.Name("second"))
let secondPublisher = NotificationCenter.default.publisher(for: secondNotification.name)

// Two ways to use zip: Publishers.Merge instance and Publisher's Merge instance function.
// Both have the same behavior:

let _ = Publishers.Merge(firstPublisher, secondPublisher)
    .sink(receiveValue: { value in
        print("\(value) merged")
    }).store(in: &cancellables)

let _ = firstPublisher.merge(with: secondPublisher)
    .sink { value in
        print("\(value) merged - with Publisher's merge intance function")
    }.store(in: &cancellables)

print("Post first")
NotificationCenter.default.post(firstNotification)

print("Post second")
NotificationCenter.default.post(secondNotification)

print("Post third")
NotificationCenter.default.post(firstNotification)

print("Post fourth")
NotificationCenter.default.post(secondNotification)

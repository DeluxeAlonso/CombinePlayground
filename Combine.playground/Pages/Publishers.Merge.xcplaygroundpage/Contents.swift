import Foundation
import Combine

var cancellables = Set<AnyCancellable>()

let firstNotification = Notification(name: Notification.Name("first"))
let firstPublisher = NotificationCenter.default.publisher(for: firstNotification.name)

let secondNotification = Notification(name: Notification.Name("second"))
let secondPublisher = NotificationCenter.default.publisher(for: secondNotification.name)

// TODO: - Merge implementation here

let _ = Publishers.Merge(firstPublisher, secondPublisher)
    .sink(receiveValue: { val in
        print("\(value) zipped")
    }).store(in: &cancellables)

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

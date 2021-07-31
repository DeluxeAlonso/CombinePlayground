import Foundation
import Combine

var cancellables = Set<AnyCancellable>()

let firstNotification = Notification(name: Notification.Name("first"))
let firstPublisher = NotificationCenter.default.publisher(for: firstNotification.name)

let secondNotification = Notification(name: Notification.Name("second"))
let secondPublisher = NotificationCenter.default.publisher(for: secondNotification.name)

// Zip waits for the two zipped publishers to emit values, otherwise it won't receive a new value
let _ = Publishers.Zip(firstPublisher, secondPublisher)
    .sink { val in
        print("\(val) zipped")
    }.store(in: &cancellables)

print("Post first")
NotificationCenter.default.post(firstNotification)

print("Post second")
NotificationCenter.default.post(secondNotification)

print("Post third")
NotificationCenter.default.post(firstNotification)

print("Post fourth")
NotificationCenter.default.post(secondNotification)

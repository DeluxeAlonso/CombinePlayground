import Foundation
import Combine

var cancellables = Set<AnyCancellable>()

// MARK: - Default NotificationCenter.Publisher

let myNotificationName = Notification.Name("com.alonso.myNotification")

NotificationCenter.default.publisher(for: myNotificationName)
    .sink(receiveValue: { notification in
        print("Received a notification!")
    }).store(in: &cancellables)

NotificationCenter.default.post(Notification(name: myNotificationName))

// MARK: - NotificationCenter.Publisher implementation using PassthroughSubject

let myPassthroughSubjectNotificationName = Notification.Name("com.alonso.passthroughSubject.myNotification")

let notificationSubjectPublisher = PassthroughSubject<Notification, Never>()

NotificationCenter.default.addObserver(
    forName: myPassthroughSubjectNotificationName,
    object: nil, queue: nil) { notification in
    notificationSubjectPublisher.send(notification)
}

notificationSubjectPublisher.sink { notification in
    print("Received a notification using PassthroughSubject!")
}.store(in: &cancellables)

NotificationCenter.default.post(Notification(name: myPassthroughSubjectNotificationName))

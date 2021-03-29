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

// A subject is a publisher that exposes a method for outside callers to publish elements.
// A PassthroughSubject is a subject that broadcasts elements to downstream subscribers.
// All the values are discarded after they are sent.
let notificationSubject = PassthroughSubject<Notification, Never>()

NotificationCenter.default.addObserver(
    forName: myPassthroughSubjectNotificationName,
    object: nil, queue: nil) { notification in
    notificationSubject.send(notification)
}

notificationSubject.sink { notification in
    print("Received a notification using PassthroughSubject!")
}.store(in: &cancellables)

NotificationCenter.default.post(Notification(name: myPassthroughSubjectNotificationName))

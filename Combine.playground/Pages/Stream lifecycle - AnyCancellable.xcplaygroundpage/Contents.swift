import Foundation
import Combine

// MARK: - AnyCancellable gets deallocated

let myNotification = Notification.Name("com.alonso.myNotification")

func listenToNotifications() {
    NotificationCenter.default.publisher(for: myNotification)
        .sink(receiveValue: { notification in
            print("Received a notification!")
        })

    NotificationCenter.default.post(Notification(name: myNotification))
    // Returned AnyCancellable by sink method is going to be deallocated when this function goes out of scope.
}

listenToNotifications()
NotificationCenter.default.post(Notification(name: myNotification)) // Does not print anything.

// MARK: - How to solve deallocating issue - Possible Solution

let myNotification1 = Notification.Name("com.alonso.myNotification1")
// Define AnyCancellable property as a stored property in class or struct.
var subscription1: AnyCancellable?

func listenToNotifications1() {
    subscription1 = NotificationCenter.default.publisher(for: myNotification1)
        .sink(receiveValue: { notification in
            print("Received a notification 1!")
        })

    NotificationCenter.default.post(Notification(name: myNotification1))
}

listenToNotifications1()
NotificationCenter.default.post(Notification(name: myNotification1))

// MARK: - How to solve deallocating issue - Better Solution

let myNotification2 = Notification.Name("com.alonso.myNotification2")
// Create AnyCancellable set to be used by the store method of an AnyCancellable instance.
var cancellables = Set<AnyCancellable>()

func listenToNotifications2() {
  NotificationCenter.default.publisher(for: myNotification2)
    .sink(receiveValue: { notification in
      print("Received a notification 2!")
    }).store(in: &cancellables)

  NotificationCenter.default.post(Notification(name: myNotification2))
}

listenToNotifications2()
NotificationCenter.default.post(Notification(name: myNotification2))

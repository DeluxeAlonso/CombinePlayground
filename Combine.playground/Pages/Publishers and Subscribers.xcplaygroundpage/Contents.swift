import UIKit
import Combine

[1, 2, 3].publisher.sink(receiveCompletion: { completion in
    print("Completed \(completion)")
}) { value in
    print(value)
}

// MARK: - Handling errors

[1, 2, 3].publisher.sink(receiveCompletion: { completion in
    switch completion {
    case .finished:
        print("finished succesfully")
    case .failure(let error):
        print(error)
    }
}, receiveValue: { value in
    print("received a value: \(value)")
})

// MARK: - Sink Shorthand - This shorthand version of sink only works for publishers that never fail.

[1, 2, 3].publisher.sink(receiveValue: { value in
    print("received a value: \(value)")
})

// MARK: - Assign

class User {
    var email = "default"
}

var user = User()
["test@email.com", "test2@email.com"].publisher.assign(to: \.email, on: user)

print(user.email)

// MARK: - NotificationCenter.Publisher

let myNotification = Notification.Name("com.alonso.myNotification")

func listenToNotifications() {
    NotificationCenter.default.publisher(for: myNotification)
        .sink(receiveValue: { notification in
            print("Received a notification!")
        })

    NotificationCenter.default.post(Notification(name: myNotification))
}

listenToNotifications()
NotificationCenter.default.post(Notification(name: myNotification))

// MARK: - Other Publisher examples

let sequencePublisher = [1, 2, 3, 4, 5].publisher
let myUrl = URL(string: "https://www.google.com")!
let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: myUrl)

let notificationCenterPusliher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)

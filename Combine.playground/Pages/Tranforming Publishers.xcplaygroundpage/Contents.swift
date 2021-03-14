import UIKit

let myLabel = UILabel()

[1, 2, 3].publisher
    .sink(receiveValue: { int in
        myLabel.text = "Current value: \(int)"
    })

myLabel.text

[1, 2, 3].publisher
    .map({ int in
        return "Current value: \(int)"
    })
    .sink { string in
        myLabel.text = string
}

myLabel.text

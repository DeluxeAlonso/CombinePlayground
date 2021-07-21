import SwiftUI
import PlaygroundSupport

struct MainView: View {

    // State property wrapper from SwiftUI framework allow us to
    // implement two-way binding, which is not the case for UIKit
    @State private var sliderValue: Float = 50

    var body: some View {
        VStack {
            Text("Slider is at \(sliderValue)")
            Slider(value: $sliderValue, in: (1...100))
        }
    }

}

let mainViewController = UIHostingController(rootView: MainView())
PlaygroundPage.current.liveView = mainViewController

import Combine

public class MainViewModel {

    // We need this property because UISlider and others UIControl subclasses are not KVO compliant.
    // Hence we cannot do something like slider.publisher(for: \.value)
    @Published var sliderValue: Float = 50

}

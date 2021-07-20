import PlaygroundSupport
import UIKit
import Combine

public class MainViewController: UIViewController {

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Test"
        label.textAlignment = .center

        return label
    }()

    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.tintColor = .red
        slider.maximumValue = 100

        return slider
    }()

    // We need this property because UISlider and others UIControl subclasses are not KVO compliant.
    // Hence we cannot do something like slider.publisher(for: \.value)
    @Published var sliderValue: Float = 50

    var cancellables = Set<AnyCancellable>()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            stackView.heightAnchor.constraint(equalToConstant: 200)
        ])

        stackView.addArrangedSubview(slider)
        stackView.addArrangedSubview(label)

        NSLayoutConstraint.activate([
            slider.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])

        $sliderValue
            .receive(on: DispatchQueue.main)
            .map({ value in
                "Slider is at \(value)"
            })
            .assign(to: \.text, on: label)
            .store(in: &cancellables)

        $sliderValue
            .receive(on: DispatchQueue.main)
            .assign(to: \.value, on: slider)
            .store(in: &cancellables)

        updateLabel()
        slider.addTarget(self, action: #selector(updateLabel), for: .valueChanged)
    }

    @objc func updateLabel() {
        sliderValue = slider.value
    }

}

let mainViewController = MainViewController()
mainViewController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 568)
PlaygroundPage.current.liveView = mainViewController


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

    private var viewModel = MainViewModel()

    private var cancellables = Set<AnyCancellable>()

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

        viewModel.$sliderValue
            .receive(on: DispatchQueue.main)
            .map({ value in
                "Slider is at \(value)"
            })
            .assign(to: \.text, on: label)
            .store(in: &cancellables)

        viewModel.$sliderValue
            .receive(on: DispatchQueue.main)
            .assign(to: \.value, on: slider)
            .store(in: &cancellables)

        updateLabel()
        slider.addTarget(self, action: #selector(updateLabel), for: .valueChanged)
    }

    @objc func updateLabel() {
        viewModel.sliderValue = slider.value
    }

}

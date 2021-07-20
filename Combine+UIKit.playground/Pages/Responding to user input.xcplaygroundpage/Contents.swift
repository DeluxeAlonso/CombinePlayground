import PlaygroundSupport
import UIKit

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

        return slider
    }()

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
    }

}

let mainViewController = MainViewController()
mainViewController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 568)
PlaygroundPage.current.liveView = mainViewController


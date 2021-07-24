import UIKit
import Combine
import PlaygroundSupport

class MainViewController: UIViewController {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16.0

        return stackView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Test"
        label.textAlignment = .center

        return label
    }()

    private lazy var textfield: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .bezel

        return textfield
    }()

    @Published var searchQuery: String?
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
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48)
        ])

        stackView.addArrangedSubview(textfield)
        stackView.addArrangedSubview(label)

        NSLayoutConstraint.activate([
            textfield.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])

        textfield.addTarget(self, action: #selector(textChanged), for: .editingChanged)

        // Wait 1 sec for the user to stop typing and have at least 3 characters typed.
        $searchQuery
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .filter({ ($0 ?? "").count > 3 })
            .assign(to: \.text, on: label)
            .store(in: &cancellables)
    }

    @objc func textChanged() {
        searchQuery = textfield.text
    }

}

let mainViewController = MainViewController()
mainViewController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 568)
PlaygroundPage.current.liveView = mainViewController

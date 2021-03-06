import UIKit
import Combine

public class MainViewController: UIViewController {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8.0

        return stackView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        return label
    }()

    private lazy var textfield: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .bezel

        return textfield
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
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48)
        ])

        stackView.addArrangedSubview(textfield)
        stackView.addArrangedSubview(label)

        NSLayoutConstraint.activate([
            textfield.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])

        textfield.addTarget(self, action: #selector(textChanged), for: .editingChanged)

        // Wait 1 sec for the user to stop typing and have at least 3 characters typed.
        // We use removeDuplicates() method to avoid processing the same input more than once.
        viewModel.$searchQuery
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .filter({ ($0 ?? "").count > 3 })
            .removeDuplicates()
            .assign(to: \.text, on: label)
            .store(in: &cancellables)
    }

    @objc func textChanged() {
        viewModel.searchQuery = textfield.text
    }

}

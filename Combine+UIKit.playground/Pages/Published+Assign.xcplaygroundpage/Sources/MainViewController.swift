import UIKit
import Combine

public final class MainViewController: UIViewController {

    private var viewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()

    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()

        viewModel.updateTitle("Test")
    }

    private func setupUI() {
        view.addSubview(label)
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     label.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }

    private func setupBindings() {
        viewModel.$title
            .assign(to: \.text, on: label)
            .store(in: &cancellables)
    }

}

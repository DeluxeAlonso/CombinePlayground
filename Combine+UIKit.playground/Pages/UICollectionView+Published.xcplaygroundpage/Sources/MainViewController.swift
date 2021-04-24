import UIKit
import Combine

public class MainViewController: UICollectionViewController {

    private var viewModel = MainViewModel()

    private var dataSource: UICollectionViewDiffableDataSource<Section, ItemModel>!
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializers

    public init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    // MARK: - Private

    private func setupUI() {
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "Cell")

        let config = UICollectionLayoutListConfiguration(appearance: .grouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView.collectionViewLayout = layout

        dataSource = UICollectionViewDiffableDataSource<Section, ItemModel>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewListCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UICollectionViewListCell
            var content = UIListContentConfiguration.cell()
            content.text = item.title

            cell.contentConfiguration = content
            return cell
        }
    }

    private func setupBindings() {
        viewModel.$items
            .sink(receiveValue: self.applySnapshot)
            .store(in: &cancellables)
        viewModel.loadItems()
    }

    private func applySnapshot(_ models: [ItemModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(models)

        dataSource.apply(snapshot)
    }
    
}

extension MainViewController {

    enum Section {
        case main
    }

}

import UIKit
import Combine

public class MainViewController: UICollectionViewController {

    enum Section {
        case main
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, ItemModel>!
    private var cancellables = Set<AnyCancellable>()

    public init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    var viewModel = MainViewModel()

    public override func viewDidLoad() {
        super.viewDidLoad()
        let config = UICollectionLayoutListConfiguration(appearance: .grouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView.collectionViewLayout = layout

        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "Cell")

        dataSource = UICollectionViewDiffableDataSource<Section, ItemModel>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewListCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? UICollectionViewListCell
            var content = UIListContentConfiguration.cell()
            content.text = item.title
            cell?.contentConfiguration = content
            return cell
        }

        viewModel.itemSubject
            .sink(receiveValue: self.applySnapshot)
            .store(in: &cancellables)
        viewModel.loadItems()
    }

    func applySnapshot(_ models: [ItemModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(models)

        dataSource.apply(snapshot)
    }

}

import UIKit
import Combine

public class MainViewController: UICollectionViewController {

    private var viewModel = MainViewModel()

    private var dataSource: UICollectionViewDiffableDataSource<Section, ItemModel>!
    private var cancellables = Set<AnyCancellable>()

    public init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        collectionView.register(CustomListCell.self, forCellWithReuseIdentifier: "Cell")

        let config = UICollectionLayoutListConfiguration(appearance: .grouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView.collectionViewLayout = layout

        dataSource = UICollectionViewDiffableDataSource<Section, ItemModel>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> CustomListCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomListCell
            var content = UIListContentConfiguration.cell()
            content.text = item.title

            // Subcribing cell to fetchImage method to update the image reactively.
            cell.cancellable = self.viewModel.fetchImage()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    print("Loaded image for cell")
                }, receiveValue: { image in
                    cell.imageView.image = image
                })

            cell.contentConfiguration = content
            return cell
        }
    }

    private func setupBindings() {
        viewModel.itemSubject
            .dropFirst()
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

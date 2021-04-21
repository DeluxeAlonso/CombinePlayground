import UIKit
import Combine

public class CustomListCell: UICollectionViewListCell {

    public let imageView = UIImageView()

    public var cancellable: Cancellable?

    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

}

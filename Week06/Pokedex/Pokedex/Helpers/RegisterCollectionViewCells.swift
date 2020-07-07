import UIKit

func registerCollectionViewCells(collectionView: UICollectionView, cellIdentifiers: [CollectionViewCellIdentifier]) {
  for cellIdentifier in cellIdentifiers {
    // Load the nib with that cellIdentifier.
    let cellNib = UINib(nibName: cellIdentifier.rawValue, bundle: nil)
    // Register cellNib to make dequeueReusableCell(withIdentifier) use the nib.
    collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier.rawValue)
  }
}

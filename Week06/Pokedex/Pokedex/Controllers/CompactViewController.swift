import UIKit

class CompactViewController: UIViewController {
  
  let dataSource = DataSource()
  let delegate = PokemonCollectionViewDelegate(numberOfItemsPerRow: 3, interItemSpacing: 8, edgesInsetSpacing: 16)
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
  }
  
  func setupCollectionView() {
    collectionView.dataSource = dataSource
    collectionView.delegate = delegate
    registerCollectionViewCells(collectionView: collectionView, cellIdentifiers: [.compactPokemonCell])
  }
  
  // MARK: Recalculate collection view layout on orientation change
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
}

import UIKit

class CompactViewController: UIViewController {
  
  let dataSource = DataSource()
  let delegate = PokemonCollectionViewDelegate(numberOfItemsPerRow: 3, interItemSpacing: 8, edgesInsetSpacing: 16)
  
  @IBOutlet weak var compactCollectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
  }
  
  func setupCollectionView() {
    compactCollectionView.dataSource = dataSource
    compactCollectionView.delegate = delegate
    registerCollectionViewCells(collectionView: compactCollectionView, cellIdentifiers: [.compactPokemonCell])
  }
  
  // MARK: Recalculate collection view layout on orientation change
  override func viewWillLayoutSubviews() {
    super.viewDidLayoutSubviews()
    compactCollectionView.collectionViewLayout.invalidateLayout()
  }
  
}

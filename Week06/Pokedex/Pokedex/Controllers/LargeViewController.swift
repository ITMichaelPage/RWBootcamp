import UIKit

class LargeViewController: UIViewController {
  
  let dataSource = DataSource()
  let delegate = PokemonCollectionViewDelegate(numberOfItemsPerRow: 1.3, interItemSpacing: 8, minimumLineSpacing: 16, topEdgeInsetSpacing: 62, leftEdgeInsetSpacing: 16, bottomEdgeInsetSpacing: 62, rightEdgeInsetSpacing: 16, squareCell: false)

  @IBOutlet weak var largeCollectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
  }
  
  func setupCollectionView() {
    largeCollectionView.dataSource = dataSource
    largeCollectionView.delegate = delegate
    registerCollectionViewCells(collectionView: largeCollectionView, cellIdentifiers: [.largePokemonCell])
  }
  
  // MARK: Recalculate collection view layout on orientation change
  override func viewWillLayoutSubviews() {
    super.viewDidLayoutSubviews()
    largeCollectionView.collectionViewLayout.invalidateLayout()
  }
  
  
  
}

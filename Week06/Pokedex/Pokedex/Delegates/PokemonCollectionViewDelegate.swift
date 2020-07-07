import UIKit

class PokemonCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
  
  let numberOfItemsPerRow: CGFloat
  let interItemSpacing: CGFloat
  let minimumLineSpacing: CGFloat
  let topEdgeInsetSpacing: CGFloat
  let leftEdgeInsetSpacing: CGFloat
  let bottomEdgeInsetSpacing: CGFloat
  let rightEdgeInsetSpacing: CGFloat
  
  init(numberOfItemsPerRow: CGFloat, interItemSpacing: CGFloat, minimumLineSpacing: CGFloat, topEdgeInsetSpacing: CGFloat, leftEdgeInsetSpacing: CGFloat, bottomEdgeInsetSpacing: CGFloat, rightEdgeInsetSpacing: CGFloat) {
    self.numberOfItemsPerRow = numberOfItemsPerRow
    self.interItemSpacing = interItemSpacing
    self.minimumLineSpacing = minimumLineSpacing
    self.topEdgeInsetSpacing = topEdgeInsetSpacing
    self.leftEdgeInsetSpacing = leftEdgeInsetSpacing
    self.bottomEdgeInsetSpacing = bottomEdgeInsetSpacing
    self.rightEdgeInsetSpacing = rightEdgeInsetSpacing
  }
  
  convenience init(numberOfItemsPerRow: CGFloat, interItemSpacing: CGFloat, edgesInsetSpacing: CGFloat) {
    self.init(numberOfItemsPerRow: numberOfItemsPerRow, interItemSpacing: interItemSpacing, minimumLineSpacing: interItemSpacing, topEdgeInsetSpacing: edgesInsetSpacing, leftEdgeInsetSpacing: edgesInsetSpacing, bottomEdgeInsetSpacing: edgesInsetSpacing, rightEdgeInsetSpacing: edgesInsetSpacing)
  }
  
  // MARK: Setting cell size
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionViewWidth = collectionView.bounds.width
    let leftAndRightEdgeInsetSpacing = leftEdgeInsetSpacing + rightEdgeInsetSpacing
    // Horizontal spacing between cells
    let totalInterItemSpacing = interItemSpacing * (numberOfItemsPerRow - 1)
    let totalSpacing = totalInterItemSpacing + leftAndRightEdgeInsetSpacing

    let itemWidth = ((collectionViewWidth - totalSpacing) / numberOfItemsPerRow).rounded(.down)
        
    return CGSize(width: itemWidth, height: itemWidth)
  }
  
  // MARK: Setting minimum horizontal padding
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return interItemSpacing
  }
  
  // MARK: Setting minimum vertical padding
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return minimumLineSpacing
  }
  
  // MARK: Setting collection view edge insets
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: topEdgeInsetSpacing, left: leftEdgeInsetSpacing, bottom: bottomEdgeInsetSpacing, right: rightEdgeInsetSpacing)
  }
  
}

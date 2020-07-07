import UIKit

class PokemonCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
  
  let numberOfItemsPerRow: CGFloat
  let interItemSpacing: CGFloat
  let minimumLineSpacing: CGFloat
  let topEdgeInsetSpacing: CGFloat
  let leftEdgeInsetSpacing: CGFloat
  let bottomEdgeInsetSpacing: CGFloat
  let rightEdgeInsetSpacing: CGFloat
  let squareCell: Bool
  
  init(numberOfItemsPerRow: CGFloat, interItemSpacing: CGFloat, minimumLineSpacing: CGFloat, topEdgeInsetSpacing: CGFloat, leftEdgeInsetSpacing: CGFloat, bottomEdgeInsetSpacing: CGFloat, rightEdgeInsetSpacing: CGFloat, squareCell: Bool = true) {
    self.numberOfItemsPerRow = numberOfItemsPerRow
    self.interItemSpacing = interItemSpacing
    self.minimumLineSpacing = minimumLineSpacing
    self.topEdgeInsetSpacing = topEdgeInsetSpacing
    self.leftEdgeInsetSpacing = leftEdgeInsetSpacing
    self.bottomEdgeInsetSpacing = bottomEdgeInsetSpacing
    self.rightEdgeInsetSpacing = rightEdgeInsetSpacing
    self.squareCell = squareCell
  }
  
  convenience init(numberOfItemsPerRow: CGFloat, interItemSpacing: CGFloat, edgesInsetSpacing: CGFloat) {
    self.init(numberOfItemsPerRow: numberOfItemsPerRow, interItemSpacing: interItemSpacing, minimumLineSpacing: interItemSpacing, topEdgeInsetSpacing: edgesInsetSpacing, leftEdgeInsetSpacing: edgesInsetSpacing, bottomEdgeInsetSpacing: edgesInsetSpacing, rightEdgeInsetSpacing: edgesInsetSpacing)
  }
  
  convenience init(numberOfItemsPerRow: CGFloat, interItemSpacing: CGFloat, edgesInsetSpacing: CGFloat, squareCell: Bool) {
    self.init(numberOfItemsPerRow: numberOfItemsPerRow, interItemSpacing: interItemSpacing, minimumLineSpacing: interItemSpacing, topEdgeInsetSpacing: edgesInsetSpacing, leftEdgeInsetSpacing: edgesInsetSpacing, bottomEdgeInsetSpacing: edgesInsetSpacing, rightEdgeInsetSpacing: edgesInsetSpacing, squareCell: squareCell)
  }
  
  // MARK: Setting cell size
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionViewWidth = collectionView.bounds.width
    let collectionViewHeight = collectionView.bounds.height
    let leftAndRightEdgeInsetSpacing = leftEdgeInsetSpacing + rightEdgeInsetSpacing
    let topAndBottomEdgeInsetSpacing = topEdgeInsetSpacing + bottomEdgeInsetSpacing
    // Horizontal spacing between cells
    let totalHorizontalInterItemSpacing = interItemSpacing * (numberOfItemsPerRow - 1)
    let totalHorizontalSpacing = totalHorizontalInterItemSpacing + leftAndRightEdgeInsetSpacing
    
    let totalVerticalSpacing = topAndBottomEdgeInsetSpacing

    let cellWidth = ((collectionViewWidth - totalHorizontalSpacing) / numberOfItemsPerRow).rounded(.down)
    let cellHeight = collectionViewHeight - totalVerticalSpacing
    
    return CGSize(width: cellWidth, height: squareCell ? cellWidth : cellHeight)
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

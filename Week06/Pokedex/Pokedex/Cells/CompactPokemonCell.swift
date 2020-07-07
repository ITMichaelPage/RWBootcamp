import UIKit

class CompactPokemonCell: UICollectionViewCell {
  
  static let reuseIdentifier = String(describing: CompactPokemonCell.self)
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.layer.cornerRadius = 6
  }
  
  func configure(for pokemon: Pokemon) {
    nameLabel.text = pokemon.name
    imageView.image = UIImage(named: String(pokemon.id))
  }
  
}

import UIKit

class CompactPokemonCell: UICollectionViewCell {
  
  static let reuseIdentifier = String(describing: CompactPokemonCell.self)
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var nameBackgroundView: UIView!
  @IBOutlet weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.layer.cornerRadius = 6
  }
  
  func configure(for pokemon: Pokemon) {
    nameLabel.text = pokemon.name
    imageView.image = UIImage(named: String(pokemon.id))
    nameBackgroundView.layer.backgroundColor = pokemon.typeSlot1IdentifierColor?.cgColor ?? #colorLiteral(red: 1, green: 0.4374197721, blue: 0.4048473537, alpha: 1).cgColor
  }
  
}

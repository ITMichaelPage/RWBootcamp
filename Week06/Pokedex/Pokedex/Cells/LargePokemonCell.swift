import UIKit

class LargePokemonCell: UICollectionViewCell {
  
  static let reuseIdentifier = String(describing: LargePokemonCell.self)
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var baseExperienceLabel: UILabel!
  @IBOutlet weak var heightLabel: UILabel!
  @IBOutlet weak var weightLabel: UILabel!
  @IBOutlet weak var pokeballImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.layer.cornerRadius = 12
  }
  
  func configure(for pokemon: Pokemon) {
    nameLabel.text = pokemon.name
    imageView.image = UIImage(named: String(pokemon.id))
    baseExperienceLabel.text = String(pokemon.baseExperience)
    heightLabel.text = String(pokemon.height)
    weightLabel.text = String(pokemon.weight)
    pokeballImageView.tintColor = pokemon.auraColor?.asUIColor()?.withAlphaComponent(0.2)
    pokeballImageView.startRotating(duration: 9.0)
  }
  
}

import UIKit

class LargePokemonCell: UICollectionViewCell {
  
  static let reuseIdentifier = String(describing: LargePokemonCell.self)
  
  @IBOutlet weak var pokemonID: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var pokemonDescription: UILabel!
  @IBOutlet weak var typeSlot1Identifier: UILabel!
  @IBOutlet weak var typeSlot2Identifier: UILabel!
  @IBOutlet weak var baseExperienceLabel: UILabel!
  @IBOutlet weak var heightLabel: UILabel!
  @IBOutlet weak var weightLabel: UILabel!
  @IBOutlet weak var pokeballImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    setupRoundedCorners()
  }
  
  func configure(for pokemon: Pokemon) {
    pokemonID.text = "No. \(String(format: "%03d", pokemon.id))"
    nameLabel.text = pokemon.name
    imageView.image = UIImage(named: String(pokemon.id))
    pokemonDescription.text = pokemon.pokemonDescription
    configureTypeSlots(for: pokemon)
    baseExperienceLabel.text = String(pokemon.baseExperience)
    heightLabel.text = String(pokemon.height)
    weightLabel.text = String(pokemon.weight)
    pokeballImageView.tintColor = pokemon.auraColor?.asUIColor()?.withAlphaComponent(0.2)
    pokeballImageView.startRotating(duration: 9.0)
  }
  
  private func setupRoundedCorners() {
    self.layer.cornerRadius = 12
    typeSlot1Identifier.layer.masksToBounds = true
    typeSlot1Identifier.layer.cornerRadius = 5
    typeSlot2Identifier.layer.masksToBounds = true
    typeSlot2Identifier.layer.cornerRadius = 5
  }
  
  private func configureTypeSlots(for pokemon: Pokemon) {
    if let typeSlot1IdentifierValue = pokemon.typeSlot1Identifier?.asCapitalizedString() {
      typeSlot1Identifier.text = " \(typeSlot1IdentifierValue) "
      typeSlot1Identifier.backgroundColor = pokemon.typeSlot1IdentifierColor
    } else {
      typeSlot1Identifier.text = ""
    }
    
    if let typeSlot2IdentifierValue = pokemon.typeSlot2Identifier?.asCapitalizedString() {
      typeSlot2Identifier.text = " \(typeSlot2IdentifierValue) "
      typeSlot2Identifier.backgroundColor = pokemon.typeSlot2IdentifierColor
    } else {
      typeSlot2Identifier.text = ""
    }
  }
  
}

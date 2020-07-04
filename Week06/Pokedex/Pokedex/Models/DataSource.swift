import UIKit

class DataSource: NSObject, UICollectionViewDataSource {
  
  let pokemons = PokemonGenerator.shared.generatePokemons()
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pokemons.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let pokemon = self.pokemons[indexPath.item]
    
    switch collectionView.tag {
    case 0:
      if let compactPokemonCell = collectionView.dequeueReusableCell(withReuseIdentifier: CompactPokemonCell.reuseIdentifier, for: indexPath) as? CompactPokemonCell {
        compactPokemonCell.configure(for: pokemon)
        return compactPokemonCell
      }
    case 1:
      if let largePokemonCell = collectionView.dequeueReusableCell(withReuseIdentifier: LargePokemonCell.reuseIdentifier, for: indexPath) as? LargePokemonCell {
        largePokemonCell.configure(for: pokemon)
        return largePokemonCell
      }
    default:
      print("Invalid collection view tag")
    }
    
    fatalError("Cell cannot be created")
  }
  
}

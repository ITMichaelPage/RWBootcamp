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
    guard let compactPokemonCell = collectionView.dequeueReusableCell(withReuseIdentifier: CompactPokemonCell.reuseIdentifier, for: indexPath) as? CompactPokemonCell else {
      fatalError("Cell cannot be created")
    }
    
    let pokemon = self.pokemons[indexPath.item]
    compactPokemonCell.configure(for: pokemon)
    
    return compactPokemonCell
  }
  
}

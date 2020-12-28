//
//  HeroCollectionViewCell.swift
//  marvel-heroes
//
//  Created by Alex Morral on 28/12/2020.
//

import UIKit
import SDWebImage

class HeroCollectionViewCell: UICollectionViewCell {
 
    var marvelCharacter: MarvelCharacter?
    
    @IBOutlet weak var lblCharacterName: UILabel!
    @IBOutlet weak var imgViewCharacter: UIImageView!
    
    func setupCell() {
        guard let marvelCharacter = marvelCharacter else { return }
        
        lblCharacterName.text = marvelCharacter.name
        
        imgViewCharacter.sd_setImage(with: URL(string: marvelCharacter.thumbnail.url), completed: nil)
    }
}

//
//  MoreInfoCollectionViewCell.swift
//  marvel-heroes
//
//  Created by Alex Morral on 06/01/2021.
//

import UIKit

class MoreInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    
    func setupCell(name: String?) {
        lblName.text = name
        viewContainer.layer.cornerRadius = 8
    }
    
}

//
//  MoreInfoCollectionView.swift
//  marvel-heroes
//
//  Created by Alex Morral on 06/01/2021.
//

import UIKit

class MoreInfoCollectionView: UICollectionView {

    var arrayOfElements = [String]()
    
    init(elements: [String]) {
        self.arrayOfElements = elements
        super.init(frame: CGRect.zero, collectionViewLayout: MoreInfoCollectionView.generateCollectionViewLayout())
        self.setupCell()
    }
    
    
    func setupCell() {
        dataSource = self
        register(UINib(nibName: "MoreInfoCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "MoreInfoCollectionViewCell")
    }
    
    static func generateCollectionViewLayout() -> UICollectionViewLayout {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 15
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.itemSize = CGSize(width: 100, height: 100)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return collectionViewLayout
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MoreInfoCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfElements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreInfoCollectionViewCell", for: indexPath) as? MoreInfoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setupCell(name: arrayOfElements[indexPath.row])
        return cell
    }
    
    
}

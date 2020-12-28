//
//  CollectionViewController.swift
//  marvel-heroes
//
//  Created by Alex Morral on 28/12/2020.
//

import UIKit

enum Section {
  case main
}

typealias DataSource = UICollectionViewDiffableDataSource<Section, MarvelCharacter>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MarvelCharacter>

class CollectionViewController: UIViewController {

    @IBOutlet weak var heroesCollectionView: UICollectionView!
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Marvel Characters"
        
        setupAppearance()
        setupHeroesCollection()
        setupData()
    }
    
    func setupAppearance() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = .black
        navBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        configureNavigationItems()
    }
    
    func configureNavigationItems() {
        let searchBtn = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(showSearchBar))
        self.navigationItem.rightBarButtonItem = searchBtn
    }
    
    @objc func showSearchBar() {
        
    }
    
    func setupData() {
        NetworkManager.getMarvelCharacters { (results) in
            //success
            DispatchQueue.main.async {
                self.applySnapshot(charactersList: results.data.results)
            }
        } failure: { (error) in
            //error
            print("ERROR: \(error)")
        }
    }
    
    func setupHeroesCollection() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        let screenWidth = UIScreen.main.bounds.width
        let itemSize = screenWidth/2
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        heroesCollectionView.collectionViewLayout = layout
    }
    
    func applySnapshot(animatingDifferences: Bool = true, charactersList: [MarvelCharacter]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(charactersList)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: heroesCollectionView,
            cellProvider: { (collectionView, indexPath, marvelCharacter) ->
                UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "HeroCollectionViewCell",
                    for: indexPath) as? HeroCollectionViewCell
                cell?.marvelCharacter = marvelCharacter
                cell?.setupCell()
                return cell
            })
        return dataSource
    }

}

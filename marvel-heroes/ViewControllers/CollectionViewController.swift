//
//  CollectionViewController.swift
//  marvel-heroes
//
//  Created by Alex Morral on 28/12/2020.
//

import UIKit
import SwiftEntryKit

private enum LoadingStatus {
    case loading, notLoading
}

class CollectionViewController: UIViewController {

    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "New Search"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.backgroundColor = .black
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barStyle = .black
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        return searchController
    }()
    
    @IBOutlet weak var heroesCollectionView: UICollectionView!
    @IBOutlet weak var lblErrorLoading: UILabel!
    
    var currentCharacters = [MarvelCharacter]()
    
    var currentSearchTerm: String?
    
    private var loadingStatus: LoadingStatus = .notLoading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Marvel Characters"
        setupNavigationAppearance()
        setupHeroesCollection()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupNavigationAppearance() {  
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        configureNavigationItems()
    }
    
    func configureNavigationItems() {
        let searchBtn = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(showSearchBar))
        self.navigationItem.rightBarButtonItem = searchBtn
    }
    
    @objc func showSearchBar() {
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }
    
    func loadData(offset: Int = 0, searchTerm: String? = nil) {
        if loadingStatus != .notLoading { return }
        loadingStatus = .loading
        if offset == 0 {
            self.currentCharacters = []
        }
        currentSearchTerm = searchTerm
        displayLoading()
        print("||| Current Offset: \(offset)")
        NetworkManager.getMarvelCharacters(searchTerm: currentSearchTerm,
                                           offset: offset, success: { (results) in
            sleep(1)
            DispatchQueue.main.async {
                self.dismissLoading()
                self.lblErrorLoading.isHidden = true
                self.currentCharacters.append(contentsOf: results.data.results)
                self.heroesCollectionView.reloadData()
                self.loadingStatus = .notLoading
            }
        }, failure: { (error) in
            print("\(error.localizedDescription)")
            DispatchQueue.main.async {
                self.dismissLoading()
                self.lblErrorLoading.isHidden = false
                self.lblErrorLoading.text = "An error occured while loading the characters. Please check the logs and try again."
                self.heroesCollectionView.isHidden = true
                self.loadingStatus = .notLoading
            }
        })
    }
    
    func displayLoading() {
        let style = EKProperty.LabelStyle(font: UIFont.systemFont(ofSize: 14), color: .white, alignment: .center, displayMode: .dark, numberOfLines: 0)
        let labelContent = EKProperty.LabelContent(text: "Loading characters", style: style)
        let contentView = EKProcessingNoteMessageView(with: labelContent, activityIndicator: .medium)
        SwiftEntryKit.display(entry: contentView, using: EKAttributes.bottomNote)
    }
    
    func dismissLoading() {
        SwiftEntryKit.dismiss()
    }
    
}

extension CollectionViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height && loadingStatus == .notLoading {
            //Sort of an infinite scrolling
            loadData(offset: currentCharacters.count, searchTerm: currentSearchTerm)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let marvelCharacter = currentCharacters[indexPath.row]
        guard let characterVC = self.storyboard?.instantiateViewController(identifier: "CharacterViewController") as? CharacterViewController else { return }
        characterVC.marvelCharacter = marvelCharacter
        characterVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(characterVC, animated: true, completion: nil)
    }
}

extension CollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResultsWith(text: searchBar.text)
    }
    
    func searchResultsWith(text: String?) {
        let searchString = text?.trimmingCharacters(in: .whitespacesAndNewlines)
        loadData(offset: 0, searchTerm: searchString)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResultsWith(text: nil)
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCharacters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCollectionViewCell.reuseIdentifier, for: indexPath) as? HeroCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.marvelCharacter = self.currentCharacters[indexPath.row]
        cell.setupCell()
        return cell
    }
}
//SETUP LAYOUT
extension CollectionViewController {
    func setupHeroesCollection() {
        heroesCollectionView.delegate = self
        heroesCollectionView.dataSource = self
        heroesCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 280 : 250)
            )
            let itemCount = isPhone ? 1 : 3
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10)
            section.interGroupSpacing = 10
            return section
        })
        
    }
}

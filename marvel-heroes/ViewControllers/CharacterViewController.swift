//
//  CharacterViewController.swift
//  marvel-heroes
//
//  Created by Alex Morral on 05/01/2021.
//

import UIKit
import SafariServices

class CharacterViewController: UIViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnMoreInfoContainer: UIView!
    @IBOutlet weak var btnMoreInfo: UIButton!
    @IBOutlet weak var btnClose: UIView!
    
    
    
    @IBOutlet weak var lblComicsContainer: UIView!
    @IBOutlet weak var comicsContainer: UIView!
    
    @IBOutlet weak var lblSeriesContainer: UIView!
    @IBOutlet weak var seriesContainer: UIView!
    
    @IBOutlet weak var lblStoriesContainer: UIView!
    @IBOutlet weak var storiesContainer: UIView!
    
    @IBOutlet weak var lblEventsContainer: UIView!
    @IBOutlet weak var eventsContainer: UIView!
    
    var marvelCharacter: MarvelCharacter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        btnClose.layer.cornerRadius = btnClose.frame.height / 2
        setupView()
        setupCollectionViews()
    }
    
    func setupView() {
        guard var marvelCharacter = marvelCharacter else {
            return
        }
        characterImageView.sd_setImage(with: URL(string: marvelCharacter.thumbnail.url), completed: nil)
        lblName.text = marvelCharacter.name
        lblDescription.text = marvelCharacter.resultDescription == "" ? "No description." : marvelCharacter.resultDescription
        btnMoreInfoContainer.isHidden = marvelCharacter.detailURL == nil
        
    }
 
    @IBAction func closeVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func knowMoreTapped(_ sender: Any) {
        if let url = marvelCharacter?.detailURL {
            let vc = SFSafariViewController(url: url, configuration: .init())
            present(vc, animated: true, completion: nil)
        }
    }
    
    func setupCollectionViews() {
        if let comics = marvelCharacter?.comics.items.compactMap({ $0.name }), comics.count > 0 {
            comicsContainer.addAndPin(view: MoreInfoCollectionView(elements: comics))
        } else {
            lblComicsContainer.isHidden = true
            comicsContainer.isHidden = true
        }
        
        if let series = marvelCharacter?.series.items.compactMap({$0.name}), series.count > 0 {
            seriesContainer.addAndPin(view: MoreInfoCollectionView(elements: series))
        } else {
            lblSeriesContainer.isHidden = true
            seriesContainer.isHidden = true
        }
        
        if let stories = marvelCharacter?.stories.items.compactMap({ $0.name }), stories.count > 0 {
            storiesContainer.addAndPin(view: MoreInfoCollectionView(elements: stories))
        } else {
            lblStoriesContainer.isHidden = true
            storiesContainer.isHidden = true
        }
        
        if let events = marvelCharacter?.events.items.compactMap({ $0.name }), events.count > 0 {
            eventsContainer.addAndPin(view: MoreInfoCollectionView(elements: events))
        } else {
            lblEventsContainer.isHidden = true
            eventsContainer.isHidden = true
        }
    }

}


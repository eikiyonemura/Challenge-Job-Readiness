//
//  DetailViewController.swift
//  Challenge Job-Readiness
//
//  Created by Douglas Eiki Yonemura on 28/06/22.
//

import UIKit

final class DetailViewController: UIViewController {
    
    let descriptioService = DescriptionService()

    var itemInfo = [String: Any]()
    
    private var favoritesArraySet = Set<String>()
    private let favorites = FavoriteItems()

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var photoImageView: UIImageView!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = UISearchBar()
        navigationItem.titleView = searchBar
        navigationItem.titleView?.isHidden = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(returnButtonTapped))
        navigationController?.navigationBar.tintColor = .black
        
        favoritesArraySet = favorites.getFavoriteItems()
        
        guard let id = itemInfo[Constants.id] as? String,
              let title = itemInfo[Constants.title] as? String,
              let image = itemInfo[Constants.photo] as? UIImage,
              let price = itemInfo[Constants.price] as? Double else { return }
        
        let imageName = favoritesArraySet.contains(id) ? "heart.fill" : "heart"
        setUpBarButtons(favoriteImage: imageName, idFavorite: id)
        
        titleLabel.text = title
        photoImageView.image = image
        priceLabel.text = "R$ " + String(format: "%.2f", locale: Locale(identifier: "pt_BR"), String(price).doubleValue)
        updateScreen(id: id)
        
    }
    
    private func updateScreen(id: String) {
        DispatchQueue.main.async {
            self.descriptioService.getDescription(itemId: id) { content in
                self.descriptionLabel.text = content?.plain_text
            }

        }
    }
    
    private func setUpBarButtons(favoriteImage: String, idFavorite: String) {
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: nil)
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: favoriteImage), style: .plain, target: self, action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItems = [cartButton, searchButton, favoriteButton]
    }

    @objc private func returnButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func favoriteButtonTapped() {
        guard let id = itemInfo["id"] as? String else { return }
        
        if favoritesArraySet.contains(id) {
            favoritesArraySet.remove(id)
            setUpBarButtons(favoriteImage: "heart", idFavorite: id)
        } else {
            favoritesArraySet.insert(id)
            setUpBarButtons(favoriteImage: "heart.fill", idFavorite: id)
        }
        
        favorites.saveFavoriteItems(itemArraySet: favoritesArraySet)

    }
}



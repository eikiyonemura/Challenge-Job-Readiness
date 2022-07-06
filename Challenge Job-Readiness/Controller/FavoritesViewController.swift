//
//  FavoritesViewController.swift
//  Challenge Job-Readiness
//
//  Created by Douglas Eiki Yonemura on 27/06/22.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    private var favoritesArraySet = Set<String>()
    private let favorites = FavoriteItems()
    
    private var itemsResult = [[String: Any]]() {
        didSet {
            favoriteTableView.reloadData()
            updateTable()
        }
    }
    
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        getFavoriteItems()
        //favoriteTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Favoritos"
        
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.register(UINib.init(nibName: "CelulaTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    
    private func updateTable() {
        messageLabel.isHidden = favoritesArraySet != [] ? true : false
    }

    private func getFavoriteItems() {
        favoritesArraySet = favorites.getFavoriteItems()
        getItemsList()
    }
    
    private func getItemsList() {
        itemsResult.removeAll()
        ItemService.getItem(itemArray: Array(favoritesArraySet)) { items in
            if items.count == 0 {
                self.messageLabel.isHidden = false
            } else {
                for item in items {
                    self.itemsResult.append([Constants.id: item.body.id,
                                             Constants.title: item.body.title,
                                             Constants.price: item.body.price,
                                             Constants.thumbnailURL: item.body.secure_thumbnail,
                                             Constants.availableQuantity: item.body.available_quantity,
                                             Constants.photoURL: item.body.pictures[0].secure_url,
                                             Constants.city: item.body.seller_address.city.name,
                                             Constants.state: item.body.seller_address.state.name])
                }
            }
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CelulaTableViewCell
        
        let itemInfo = ItemInfo.getItemInfo(index: indexPath.row, array: itemsResult)
        
        guard let id = itemInfo[Constants.id] as? String else { return cell }

        let itemFavorite =  favoritesArraySet.contains(id) ? true : false
        
        cell.set(itemInfo, itemFavorite)
    
        cell.favoritar = {

            if self.favoritesArraySet.contains(id) {
                self.favoritesArraySet.remove(id)
                self.itemsResult.remove(at: indexPath.row)
                cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            self.favorites.saveFavoriteItems(itemArraySet: self.favoritesArraySet)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var itemInfo = ItemInfo.getItemInfo(index: indexPath.row, array: itemsResult)
        let detailVC = DetailViewController()
        let photo = ItemService.getImage(itemInfo[Constants.photoURL] as? String)
        itemInfo[Constants.photo] = photo
        detailVC.itemInfo = itemInfo
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
    
    


//
//  ListViewController.swift
//  Challenge Job-Readiness
//
//  Created by Douglas Eiki Yonemura on 27/06/22.
//

import UIKit

final class ListViewController: UIViewController {
    
    private var lista: [String] = []
    
    private var itemsResult = [[String: Any]]() {
        didSet {
            listTableView.reloadData()
        }
    }
    
    private var favoritesArraySet = Set<String>()
    private let favorites = FavoriteItems()
    
    private let categoryService = CategoryService()
    private let listService = ListService()
    private let descriptionService = DescriptionService()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        getFavoriteItems()
        listTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageLabel.isHidden = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: nil)
        
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        activityIndicator.style = .large
        activityIndicator.color = .white
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Buscar em Mercado Livre"
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.layer.cornerRadius = 18
        searchBar.searchTextField.clipsToBounds = true
        searchBar.searchTextField.layer.masksToBounds = true
        navigationItem.titleView = searchBar

        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UINib.init(nibName: "CelulaTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        getItemsList(searchCategory: "celular")
        
    }
    
    private func getFavoriteItems() {
        favoritesArraySet = favorites.getFavoriteItems()
    }
    
    private func getItemsList(searchCategory: String) {
        lista.removeAll()
        itemsResult.removeAll()
        categoryService.getCategory(category: searchCategory) { category in
            self.startActivity()
            if category.isEmpty {
                print("Erro ao procurar categoria")
                self.alertaErro()
                return
            } else {
                self.listService.getList(category: category[0].category_id) { content in
                    guard let content = content else {
                        print("Erro ao procurar top 20")
                        self.alertaErro()
                        return
                    }
                    for content in content.content {
                        if content.type == "ITEM" {
                            self.lista.append(content.id)
                        }
                    }
                    if self.lista.count == 0 {
                        print("N??o existem itens")
                        self.alertaErro()
                        return
                    } else {
                        self.messageLabel.isHidden = true
                        ItemService.getItem(itemArray: self.lista) { items in
                            if items.count == 0 {
                                print("Erro ao procurar itens")
                                self.alertaErro()
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
                                self.stopActivity()
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    private func alertaErro() {
        stopActivity()
        let ac = UIAlertController(title: "Desculpe", message: "N??o foram encontrados itens com essa busca", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in 
            //self.stopActivity()
        }))
        self.present(ac, animated: true)
        messageLabel.isHidden = false
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
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
                cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            } else {
                self.favoritesArraySet.insert(id)
                cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
            self.favorites.saveFavoriteItems(itemArraySet: self.favoritesArraySet)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailViewController()
        var itemInfo = ItemInfo.getItemInfo(index: indexPath.row, array: itemsResult)
        let photo = ItemService.getImage(itemInfo[Constants.photoURL] as? String)
        itemInfo[Constants.photo] = photo
        detailVC.itemInfo = itemInfo
        navigationController?.pushViewController(detailVC, animated: true)

    }
    
}

// MARK: UISeachBarDelegate

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let search = searchBar.text else { return }
        searchBar.resignFirstResponder()
        let searchWithNoSpace = search.filter({ !$0.isWhitespace })
        getItemsList(searchCategory: searchWithNoSpace)
    }
}

// MARK: Loading screen

extension ListViewController {
    
    private func startActivity() {
        self.loadingView.isHidden = false
        self.activityIndicator.hidesWhenStopped = false
        self.activityIndicator.startAnimating()
    }
    
    private func stopActivity() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
        self.loadingView.isHidden = true
    }
}



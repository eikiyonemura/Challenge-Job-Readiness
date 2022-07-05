//
//  ItemService.swift
//  Challenge Job-Readiness
//
//  Created by Douglas Eiki Yonemura on 28/06/22.
//

import Foundation
import Alamofire

final class ItemService {

    //private let apiClient = AlamofireAPIClient()
    //private let url = "https://api.mercadolibre.com/items?ids="

    static func getItem(itemArray: [String], completion: @escaping ([ResultItem]) -> Void) {
        
        var urlItem = "https://api.mercadolibre.com/items?ids="
        
        for produto in itemArray {
            if produto == itemArray.first {
                urlItem += produto
            } else {
                urlItem += ",\(produto)"
            }
        }
        //print("URL Items: \(urlItem)")
        let apiClient = AlamofireAPIClient()
        apiClient.get(url: urlItem, token: Constants.token) { response in
            switch response {
            case .success(let data):
                do {
                    if let data = data {
                        let item = try JSONDecoder().decode([ResultItem].self, from: data)
                        completion(item)
                    }
                } catch {
                    completion([])
                }
            case.failure(_):
                completion([])
            }
        }
    }
    
    static func getImage(_ itemsResult: String?) -> UIImage? {
        guard let thumbnail = itemsResult, let urlString = URL.init(string: thumbnail) else { return nil }
        do{
            let data = try Data(contentsOf: urlString)
            return UIImage(data: data)
        } catch {
            print(error)
            return nil
        }
    }
}

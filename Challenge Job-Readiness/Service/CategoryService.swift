//
//  CategoryService.swift
//  Challenge Job-Readiness
//
//  Created by Douglas Eiki Yonemura on 28/06/22.
//

import Foundation
import Alamofire

final class CategoryService {
    
    private let apiClient = AlamofireAPIClient()
    private let url = "https://api.mercadolibre.com/sites/MLB/domain_discovery/search?limit=1&q="
    
    func getCategory(category: String, completion: @escaping ([Category]) -> Void) {
        let urlCategory = url + category
        //print("URL Category: \(urlCategory)")
        apiClient.get(url: urlCategory, token: Constants.token) { response in
            switch response {
            case .success(let data):
                do {
                    if let data = data {
                        let category = try JSONDecoder().decode([Category].self, from: data)
                        completion(category)
                    }
                } catch {
                    completion([])
                }
            case.failure(_):
                completion([])
            }
        }
    }
}

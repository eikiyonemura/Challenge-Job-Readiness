//
//  DescriptionService.swift
//  Challenge Job-Readiness
//
//  Created by Douglas Eiki Yonemura on 04/07/22.
//

import Foundation
import Alamofire

final class DescriptionService {
    
    private let apiClient = AlamofireAPIClient()
    private let url = "https://api.mercadolibre.com/items/"
        
    func getDescription(itemId: String, completion: @escaping (Description?) -> Void) {
        let urlList = url + itemId + "/description"

        apiClient.get(url: urlList, token: Constants.token) { response in
            switch response {
            case .success(let data):
                do {
                    if let data = data {
                        let sugestion = try JSONDecoder().decode(Description.self, from: data)
                        completion(sugestion)
                    }
                } catch {
                    completion(nil)
                }
            case.failure(_):
                completion(nil)
            }
        }
    }
}

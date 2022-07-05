//
//  ListService.swift
//  Challenge Job-Readiness
//
//  Created by Douglas Eiki Yonemura on 27/06/22.
//

import Foundation
import Alamofire

final class ListService {

    private let apiClient = AlamofireAPIClient()
    private let url = "https://api.mercadolibre.com/highlights/MLB/category/"

    func getList(category: String, completion: @escaping (Content?) -> Void) {
        let urlList = url + category + "?="
        //print("URL List: \(urlList)")
        apiClient.get(url: urlList, token: Constants.token) { response in
            switch response {
            case .success(let data):
                do {
                    if let data = data {
                        let sugestion = try JSONDecoder().decode(Content.self, from: data)
                        completion(sugestion)
   
                    }
                } catch {
                    completion(nil)
                }
            case.failure(_):
                print("Erro ao carregar top 20")
                completion(nil)
            }
        }
    }
}

class AlamofireAPIClient {
    func get(url: String, token: String, completion: @escaping (Result<Data?, AFError>) -> Void) {
        let headers: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        AF.request(url, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).response { response in
            completion(response.result)
        }

    }
}

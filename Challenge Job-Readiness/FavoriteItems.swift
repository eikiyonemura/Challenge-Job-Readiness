//
//  FavoriteItems.swift
//  Challenge Job-Readiness
//
//  Created by Douglas Eiki Yonemura on 01/07/22.
//

import Foundation

final class FavoriteItems {
 
    let favorites = UserDefaults.standard
    
    func getFavoriteItems() -> Set<String> {
        if let data = favorites.data(forKey: "favorite") {
            do {
                let decoder = JSONDecoder()
                let set = try decoder.decode(Set<String>.self, from: data)
                return set
            } catch {
                print("Erro ao carregar favoritos")
            }
        }
        return []
    }
    
    func saveFavoriteItems(itemArraySet: Set<String>) {
        do {
            let encoder = JSONEncoder()
            let data =  try encoder.encode(itemArraySet)
            favorites.set(data, forKey: "favorite")
        } catch {
            print("Erro ao salvar favoritos")
        }
    }
}

//
//  Teste.swift
//  Challenge Job-Readiness
//
//  Created by Douglas Eiki Yonemura on 05/07/22.
//

import Foundation

final class ItemInfo {
    
    static func getItemInfo(index: Int, array: [[String: Any]]) -> [String: Any] {
        
        var itemInfo = [String: Any]()
        
        guard let title = array[index][Constants.title],
              let thumbnailURL = array[index][Constants.thumbnailURL],
              let photoURL = array[index][Constants.photoURL],
              let price = array[index][Constants.price],
              let id = array[index][Constants.id],
              let thumbnail = ItemService.getImage(thumbnailURL as? String),
              let quantity = array[index][Constants.availableQuantity],
              let city = array[index][Constants.city],
              let state = array[index][Constants.state] else { return [:] }
        
        itemInfo = [Constants.title: title,
                    Constants.thumbnail: thumbnail,
                    Constants.availableQuantity: quantity,
                    Constants.photoURL: photoURL,
                    Constants.price: price,
                    Constants.id: id,
                    Constants.city: city,
                    Constants.state: state] as [String : Any]
        
        return itemInfo
    }
    
}

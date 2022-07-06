//
//  CelulaTableViewCell.swift
//  Challenge Job-Readiness
//
//  Created by Douglas Eiki Yonemura on 05/07/22.
//

import UIKit

final class CelulaTableViewCell: UITableViewCell {
    
    var favoritar: (() -> Void)? = nil
            
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var subtitle1Label: UILabel!
    @IBOutlet weak var subtitle2Label: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        favoriteButton.alpha = 0.8
        
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        
        favoritar?()
        
    }
    
    func set(_ itemInfo: [String:Any], _ favorite: Bool) {
        guard let title = itemInfo[Constants.title] as? String,
              let price = itemInfo[Constants.price] as? Double,
              let thumbnail = itemInfo[Constants.thumbnail] as? UIImage,
              let availableQuantity = itemInfo[Constants.availableQuantity] as? Int,
              let city = itemInfo[Constants.city] as? String,
              let state = itemInfo[Constants.state] as? String else { return  }
        
        titleLabel.text = title
        priceLabel.text = "R$ " + String(format: "%.2f", locale: Locale(identifier: "pt_BR"), String(price).doubleValue)
        itemImageView.image = thumbnail
        subtitle1Label.text = "Quantidade disponível: \(availableQuantity)"
        subtitle2Label.text = "\(city) - \(state)"

        let imageName = favorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
        

}

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
    
  
    

}

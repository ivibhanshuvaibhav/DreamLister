//
//  ItemCell.swift
//  DreamLister
//
//  Created by Vibhanshu Vaibhav on 02/12/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    func configureCell(item: Item) {
        self.titleLabel.text = item.title
        if item.price.description.split(separator: ".")[1] == "0" {
            self.priceLabel.text = "\(getCurrencySymbol()) \(item.price.description.split(separator: ".")[0].description)"
        } else {
            self.priceLabel.text = "\(getCurrencySymbol()) \(item.price.description)"
        }
        self.descriptionLabel.text = item.details
        if item.image == nil {
            self.itemImage.image = UIImage(named: "imagePick")
        } else {
            self.itemImage.image = item.image as? UIImage
        }
        
    }
    
}

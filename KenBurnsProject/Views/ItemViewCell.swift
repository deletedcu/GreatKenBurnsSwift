//
//  ItemViewCell.swift
//  KenBurnsProject
//
//  Created by King on 2019/10/28.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

class ItemViewCell: UICollectionViewCell {
    static let reuseIdentifier = "\(ItemViewCell.self)"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(media: Media) {
        titleLabel.text = media.title
        descriptionLabel.text = media.description
    }
}

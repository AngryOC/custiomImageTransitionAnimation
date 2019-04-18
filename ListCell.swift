//
//  ListCell.swift
//  animationtest
//
//  Created by wang chao on 2019/4/11.
//  Copyright © 2019 bigfish. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    var model: String? {
        didSet{
            guard let model = model else {
                return
            }
            if model.contains("http") {
                
            } else {
                imageV.image = UIImage(named: model)
            }
        }
    }
    
    
    @IBOutlet weak var imageV: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

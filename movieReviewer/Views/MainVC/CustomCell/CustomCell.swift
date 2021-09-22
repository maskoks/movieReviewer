//
//  CustomCell.swift
//  movieReviewer
//
//  Created by Жеребцов Данил on 09.09.2021.
//

import UIKit

class CustomCell: UICollectionViewCell {

    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentImageView.layer.cornerRadius = 15
    }

}

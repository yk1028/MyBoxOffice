//
//  MoviesTableViewCell.swift
//  MyBoxOffice
//
//  Created by Wongeun Song on 2018. 12. 9..
//  Copyright © 2018년 Wongeun Song. All rights reserved.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var thumbImageView: UIImageView!
    @IBOutlet var gradeImageView: UIImageView!
    
    var movieId: String?

    override func prepareForReuse() {
        titleLabel.text = nil
        infoLabel.text = nil
        dateLabel.text = nil
        thumbImageView.image = nil
        gradeImageView.image = nil
    }
}

//
//  CommentsTableViewCell.swift
//  MyBoxOffice
//
//  Created by Wongeun Song on 2018. 12. 15..
//  Copyright © 2018년 Wongeun Song. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var contentsText: UITextView!
    
    @IBOutlet var starImage1: UIImageView!
    @IBOutlet var starImage2: UIImageView!
    @IBOutlet var starImage3: UIImageView!
    @IBOutlet var starImage4: UIImageView!
    @IBOutlet var starImage5: UIImageView!
    
    @IBOutlet var starImages: [UIImageView]!

}

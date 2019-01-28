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
    
    func configure(_ movie: Movie) {
        titleLabel.text = movie.title
        infoLabel.text = movie.fullInfoInTable
        dateLabel.text = movie.releaseDate
        
        var grade: String
        switch movie.grade {
        case 0:
            grade = "ic_allages"
        case 12:
            grade = "ic_12"
        case 15:
            grade = "ic_15"
        case 19:
            grade = "ic_19"
        default:
            grade = "img_placeholder"
        }
        
        gradeImageView.image = UIImage(named: grade)
        
        movieId = movie.id
        
        if let imageURL: URL = URL(string: movie.thumb) {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            
            OperationQueue().addOperation {
                
                do {
                    let imageData: Data = try Data.init(contentsOf: imageURL)
                    if let image: UIImage = UIImage(data: imageData){
                        OperationQueue.main.addOperation {
                            self.thumbImageView.image = image
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }

}

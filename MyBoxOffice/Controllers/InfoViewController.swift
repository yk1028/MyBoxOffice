//
//  InfoViewController.swift
//  MyBoxOffice
//
//  Created by Wongeun Song on 2018. 12. 9..
//  Copyright © 2018년 Wongeun Song. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet var titleItem: UINavigationItem!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var gradeImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var genreAndDurationLabel: UILabel!
    @IBOutlet var reservationLabel: UILabel!
    @IBOutlet var userRatingLabel: UILabel!
    @IBOutlet var audienceLabel: UILabel!
    @IBOutlet var directorLabel: UILabel!
    @IBOutlet var actorLabel: UILabel!
    
    @IBOutlet var starImage1: UIImageView!
    @IBOutlet var starImage2: UIImageView!
    @IBOutlet var starImage3: UIImageView!
    @IBOutlet var starImage4: UIImageView!
    @IBOutlet var starImage5: UIImageView!
    
    @IBOutlet var synopsisTextView: UITextView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var totalStackView: UIStackView!
    @IBOutlet var ratingStackView: UIStackView!
    @IBOutlet var synopsisView: UIView!
    @IBOutlet var directorAndActorView: UIView!
    @IBOutlet var commentTitleView: UIView!
    @IBOutlet var tableView: UITableView!
    
    let commentCellIdentifier: String = "commentCell"
    var comments: [Comment] = []
    var movieId: String!
    var borders: [CALayer] = []

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRecieveMovieInfoNotification(_:)), name: DidReceiveMovieInfoNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRecieveMovieCommentsNotification(_:)), name: DidReceiveMovieCommentsNotification, object: nil)
        
        requestMovieInfo(id: movieId) { [weak self] (error) in
            if let error = error {
                self?.alertFailMessage(errorMessage: error.localizedDescription)
            }
        }
        requestMovieComments(id: movieId) { [weak self] (error) in
            if let error = error {
                self?.alertFailMessage(errorMessage: error.localizedDescription)
            }
        }
        
        initBorders()
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Set table view height by contents size
        var height: CGFloat = 0
        for comment in comments {
            height += CGFloat(100 + (comment.contents.count / 100) * 30)
        }
        NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.height, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        self.relocationBorders() // Repositioning borders when device was rotated.
    }
    
    @objc func didRecieveMovieInfoNotification(_ noti: Notification) {
        guard let movieInfo: MovieInfo = noti.userInfo?["movie"] as? MovieInfo else { return }
        
        DispatchQueue.main.async { [weak self] in
            if let imageURL: URL = URL(string: movieInfo.image) {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                OperationQueue().addOperation {
                    do {
                        let imageData: Data = try Data.init(contentsOf: imageURL)
                        if let image: UIImage = UIImage(data: imageData){
                            OperationQueue.main.addOperation {
                                self?.imageView.image = image
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
            
            if let self = self {
                self.titleItem.title = movieInfo.title
                
                var grade: String
                switch movieInfo.grade {
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
                
                self.gradeImageView.image = UIImage(named: grade)
                
                self.titleLabel.text = movieInfo.title
                self.dateLabel.text = movieInfo.date + "개봉"
                self.genreAndDurationLabel.text = movieInfo.genreAndDuration
                self.reservationLabel.text = movieInfo.reservationInfo
                self.userRatingLabel.text = String(movieInfo.userRating)
                
                self.setStarRating(rating: movieInfo.userRating, stars: [self.starImage1, self.starImage2, self.starImage3, self.starImage4, self.starImage5])
                
                //seperate audience with ','
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let audience = numberFormatter.string(from: NSNumber(value: movieInfo.audience))!
                self.audienceLabel.text = audience
                
                self.synopsisTextView.text = movieInfo.synopsis
                self.directorLabel.text = movieInfo.director
                self.actorLabel.text = movieInfo.actor
            }
            
        }
    }
    
    @objc func didRecieveMovieCommentsNotification(_ noti: Notification) {
        
        guard let data: [Comment] = noti.userInfo?["comments"] as? [Comment] else { return }

        comments = data
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Custom function
    // Convert `timestamp` to 'yyyy-MM-dd HH:mm:ss' format
    func timestampToString(_ timestamp: Double) -> String {
        
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    
    // Fill `stars` with images based on `rating`
    func setStarRating(rating: Double, stars: [UIImageView]) {
        if stars.count != 5 { return }
        
        let intRating = Int(rating)
        
        for i in 0 ..< stars.count {
            if intRating >= (i + 1) * 2 {
                stars[i].image = UIImage(named: "ic_star_large_full")
            } else {
                if intRating % 2 == 1 {
                    stars[i].image = UIImage(named: "ic_star_large_half")
                }
                break
            }
        }
    }
    
    //Alert `errorMessage` in `viewController`.
    func alertFailMessage(errorMessage: String) {
        let alertController: UIAlertController
        alertController = UIAlertController(title: "ERROR!", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction: UIAlertAction
        cancelAction = UIAlertAction(title: "닫기", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Border
    func initBorders() {
        for _ in 0..<5 {
            borders.append(CALayer())
        }
        
        for border in borders {
            border.backgroundColor = UIColor.lightGray.cgColor
        }
        
        synopsisView.layer.addSublayer(borders[0])
        directorAndActorView.layer.addSublayer(borders[1])
        commentTitleView.layer.addSublayer(borders[2])
        ratingStackView.layer.addSublayer(borders[3])
        ratingStackView.layer.addSublayer(borders[4])
    }
    
    func relocationBorders() {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        borders[0].frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 8.0)
        borders[1].frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 8.0)
        borders[2].frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 8.0)
        borders[3].frame = CGRect.init(x: 0, y: 0, width: 1.0, height: ratingStackView.frame.height)
        borders[4].frame = CGRect.init(x: screenWidth / 3.0, y: 0, width: 1.0, height: ratingStackView.frame.height)
    }
    
    // Tap the Image to full screen
    @objc func imageTapped() {
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        view.addSubview(newImageView)
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    //Dismiss full screen
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
}

extension InfoViewController: UITableViewDataSource {
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CommentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: commentCellIdentifier, for: indexPath) as? CommentsTableViewCell ?? CommentsTableViewCell()
        
        let comment: Comment = comments[indexPath.row]
        
        cell.userNameLabel.text = comment.writer
        cell.timestampLabel.text = timestampToString(comment.timestamp)
        cell.contentsText.text = comment.contents
        
        setStarRating(rating: comment.rating, stars: [cell.starImage1, cell.starImage2, cell.starImage3, cell.starImage4, cell.starImage5])
        
        return cell
    }
    
    // MARK: Table view delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let comment: Comment = comments[indexPath.row]
        let height: CGFloat = CGFloat(100 + (comment.contents.count / 100) * 30)
        
        return height
    }
}

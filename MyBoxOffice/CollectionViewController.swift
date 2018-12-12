//
//  CollectionViewController.swift
//  MyBoxOffice
//
//  Created by Wongeun Song on 2018. 12. 9..
//  Copyright © 2018년 Wongeun Song. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let cellIdentifier: String = "collectionCell"
    var movies: [Movie] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //as! 안쓰고 안전하게 하는방법? guard사용
        let cell: MoviesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! MoviesCollectionViewCell
        
        let movie: Movie = self.movies[indexPath.item]
        
        cell.titleLabel?.text = movie.title
        cell.infoLabel?.text = movie.fullInfoInCollection
        cell.dateLabel?.text = movie.releaseDate
        
        //url
        let imageURL: URL = URL(string: movie.thumb)!
        
        //dispatchQueue?
        OperationQueue().addOperation {
            let imageData: Data = try! Data.init(contentsOf: imageURL)
            let image: UIImage = UIImage(data: imageData)!
            
            OperationQueue.main.addOperation {
                cell.thumbImageView?.image = image
            }
        }
        
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
        
        cell.gradeImageView?.image = UIImage(named: grade)
        
        return cell
    }
    
    
    
    // MARK: Life Cylce
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRecieveMovieNotification(_:)), name: DidReceiveMoviesNotification, object: nil)
        
        let flowLayout: UICollectionViewFlowLayout
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        let halfWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        let halfheight: CGFloat = UIScreen.main.bounds.height / 2.0
        
        //flowLayout.estimatedItemSize = CGSize(width: halfWidth - 30, height: 90) // 예상.. 오토레이아웃에의해 변경 될 수 있다.
        flowLayout.itemSize = CGSize(width: halfWidth - 16, height: halfheight - 30) // 이렇게하면 크기 고정은 가능, 기기마다 호환은? -> 오토레이아웃 적용시킬 방법?
        
        self.collectionView.collectionViewLayout = flowLayout
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestMovies()
    }
    
    @objc func didRecieveMovieNotification(_ noti: Notification) {
        
        guard let movies: [Movie] = noti.userInfo?["movies"] as? [Movie] else { return }
        
        self.movies = movies
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

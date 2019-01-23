//
//  CollectionViewController.swift
//  MyBoxOffice
//
//  Created by Wongeun Song on 2018. 12. 9..
//  Copyright © 2018년 Wongeun Song. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var titleItem: UINavigationItem!
    
    let cellIdentifier: String = "collectionCell"
    var movies: [Movie] = []
    
    private var refreshControl = UIRefreshControl()
    
    // MARK: - IBActions
    @IBAction func touchUpOrderButton(_ sender: UIBarButtonItem) {
        self.showActionSheetController()
    }
    
    // MARK: - Collection view data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MoviesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? MoviesCollectionViewCell ?? MoviesCollectionViewCell()
        
        let movie: Movie = self.movies[indexPath.item]
        
        cell.titleLabel.text = movie.title
        cell.infoLabel.text = movie.fullInfoInCollection
        cell.dateLabel.text = movie.releaseDate
        
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
        
        cell.gradeImageView.image = UIImage(named: grade)
        
        cell.movieId = movie.id
        
        if let imageURL: URL = URL(string: movie.thumb) {
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            
            OperationQueue().addOperation {
                
                do {
                    let imageData: Data = try Data.init(contentsOf: imageURL)
                    if let image: UIImage = UIImage(data: imageData){
                        OperationQueue.main.addOperation {
                            cell.thumbImageView.image = image
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
        
        return cell
    }
    
    // MARK: - Life Cylce
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addFlowLayout()
        addPullToRefresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRecieveMovieNotification(_:)), name: DidReceiveMoviesNotification, object: nil)
        
        requestMovies(){
            (error) in
            if let error = error {
                self.AlertFailMessage(errorMessage: error.localizedDescription)
            }
        }
    }
    
    @objc func didRecieveMovieNotification(_ noti: Notification) {
        
        guard let movies: [Movie] = noti.userInfo?["movies"] as? [Movie] else { return }
        
        self.movies = movies
        
        DispatchQueue.main.async {
            if OrderType.orderTypeProperty == 0 {
                self.titleItem.title = "예매율 순"
            } else if OrderType.orderTypeProperty == 1 {
                self.titleItem.title = "큐레이션 순"
            } else if OrderType.orderTypeProperty == 2 {
                self.titleItem.title = "개봉일 순"
            }
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Layout
    func addFlowLayout() {
        let flowLayout: UICollectionViewFlowLayout
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        let halfWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        let halfheight: CGFloat = UIScreen.main.bounds.height / 2.0
        
        flowLayout.itemSize = CGSize(width: halfWidth - 16, height: halfheight)
        
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    // MARK: - Refresh
    func addPullToRefresh() {
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        requestMovies(){
            (error) in
            if let error = error {
                self.AlertFailMessage(errorMessage: error.localizedDescription)
            }
        }
        self.collectionView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    // MARK: - Action sheet
    func showActionSheetController() {
        let actionSheetController: UIAlertController
        actionSheetController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let reservationRateAction: UIAlertAction
        reservationRateAction = UIAlertAction(title: "예매율", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
            OrderType.orderTypeProperty = 0
            requestMovies(){
                (error) in
                if let error = error {
                    self.AlertFailMessage(errorMessage: error.localizedDescription)
                }
            }
        })
        
        let curationAction: UIAlertAction
        curationAction = UIAlertAction(title: "큐레이션", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
            OrderType.orderTypeProperty = 1
            requestMovies(){
                (error) in
                if let error = error {
                    self.AlertFailMessage(errorMessage: error.localizedDescription)
                }
            }
        })
        
        let releaseDateAction: UIAlertAction
        releaseDateAction = UIAlertAction(title: "개봉일", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
            OrderType.orderTypeProperty = 2
            requestMovies(){
                (error) in
                if let error = error {
                    self.AlertFailMessage(errorMessage: error.localizedDescription)
                }
            }
        })
        
        let cancelAction: UIAlertAction
        cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: nil)
        
        actionSheetController.addAction(reservationRateAction)
        actionSheetController.addAction(curationAction)
        actionSheetController.addAction(releaseDateAction)
        actionSheetController.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = actionSheetController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                self.present(actionSheetController, animated: true, completion: nil)
            }
        }
        else {
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    //Alert `errorMessage` in `viewController`.
    func AlertFailMessage(errorMessage: String) {
        let actionSheetController: UIAlertController
        actionSheetController = UIAlertController(title: "ERROR!", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction: UIAlertAction
        cancelAction = UIAlertAction(title: "닫기", style: UIAlertActionStyle.cancel, handler: nil)
        
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        guard let nextViewController: InfoViewController = segue.destination as? InfoViewController else { return }
        guard let cell: MoviesCollectionViewCell = sender as? MoviesCollectionViewCell else { return }
        guard let movieId = cell.movieId else { return }
        
        nextViewController.movieId = movieId
    }
}

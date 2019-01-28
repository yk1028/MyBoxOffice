//
//  TableViewController.swift
//  MyBoxOffice
//
//  Created by Wongeun Song on 2018. 12. 9..
//  Copyright © 2018년 Wongeun Song. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var titleItem: UINavigationItem!
    
    let movieCellIdentifier: String = "tableCell"
    var movies: [Movie] = []
    
    private var refreshControl = UIRefreshControl()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        AddPullToRefresh()
        
        //Add Observer for movies data
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRecieveMoviesNotification(_:)), name: DidReceiveMoviesNotification, object: nil)
        
        requestMovies(){
            (error) in
            if let error = error {
                self.AlertFailMessage(errorMessage: error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - IBActions
    @IBAction func touchUpOrderButton(_ sender: UIBarButtonItem) {
        self.showActionSheetController()
    }
    
    
    
    @objc func didRecieveMoviesNotification(_ noti: Notification) {
        
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
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Refresh
    func AddPullToRefresh() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
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
        self.tableView.reloadData()
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
        guard let cell: MoviesTableViewCell = sender as? MoviesTableViewCell else { return }
        guard let movieId = cell.movieId else { return }
        
        nextViewController.movieId = movieId
        
    }
    
}

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MoviesTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.movieCellIdentifier, for: indexPath) as? MoviesTableViewCell ?? MoviesTableViewCell()
        
        let movie: Movie = self.movies[indexPath.row]
        
        cell.configure(movie)
        
        return cell
    }
    
    // MARK: Table view delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 130.0;
    }
}

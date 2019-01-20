//
//  TableViewController.swift
//  MyBoxOffice
//
//  Created by Wongeun Song on 2018. 12. 9..
//  Copyright © 2018년 Wongeun Song. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var titleItem: UINavigationItem!
    
    let movieCellIdentifier: String = "tableCell"
    var movies: [Movie] = []
    
    private var refreshControl = UIRefreshControl()
    
    // MARK: - IBActions
    @IBAction func touchUpOrderButton(_ sender: UIBarButtonItem) {
        self.showActionSheetController()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MoviesTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.movieCellIdentifier, for: indexPath) as? MoviesTableViewCell ?? MoviesTableViewCell()
        
        let movie: Movie = self.movies[indexPath.row]
        
        cell.titleLabel.text = movie.title
        cell.infoLabel.text = movie.fullInfoInTable
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
    
    // MARK: Table view delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 130.0;
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addPullToRefresh()
        
        //Add Observer for movies data
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRecieveMoviesNotification(_:)), name: DidReceiveMoviesNotification, object: nil)
        
        self.requestMoviesWithEscaping()

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
    func addPullToRefresh() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    @objc func refresh() {
        self.requestMoviesWithEscaping()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
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

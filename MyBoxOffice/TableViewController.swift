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
    
    let movieCellIdentifier: String = "tableCell"
    var movies: [Movie] = []
    
    private var refreshControl = UIRefreshControl()
    
    // MARK: Tableview DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MoviesTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.movieCellIdentifier, for: indexPath) as! MoviesTableViewCell // 강제 캐스팅 말고 더 좋은 방법?
        
        let movie: Movie = self.movies[indexPath.row]
        
        cell.titleLabel?.text = movie.title
        cell.infoLabel?.text = movie.fullInfoInTable
        cell.dateLabel?.text = movie.releaseDate
        
        let imageURL: URL = URL(string: movie.thumb)!

        //dispatchQueue?
        OperationQueue().addOperation {
            let imageData: Data = try! Data.init(contentsOf: imageURL)
            let image: UIImage = UIImage(data: imageData)!

            OperationQueue.main.addOperation {
                cell.thumbImageView?.image = image // UI와 관련된 코드는 메인 스레드에서 동작해야함
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
    
    // MARK: Tableview Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 130.0;
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addPullToRefresh()
        
        //Add Observer for movies data
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRecieveMovieNotification(_:)), name: DidReceiveMoviesNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestMovies(0)
    }
    
    @objc func didRecieveMovieNotification(_ noti: Notification) {
        
        guard let movies: [Movie] = noti.userInfo?["movies"] as? [Movie] else { return }
        
        self.movies = movies
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Refresh
    func addPullToRefresh() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    @objc func refresh() {
        // refresh Action
        
        requestMovies(1)
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
    
    
}


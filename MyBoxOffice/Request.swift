//
//  Request.swift
//  MyBoxOffice
//
//  Created by Wongeun Song on 2018. 12. 9..
//  Copyright © 2018년 Wongeun Song. All rights reserved.
//

import Foundation
import UIKit

let DidReceiveMoviesNotification: Notification.Name = Notification.Name("DidRecieveMovies")
let DidReceiveMovieInfoNotification: Notification.Name = Notification.Name("DidRecieveMovieInfo")
let DidReceiveMovieCommentsNotification: Notification.Name = Notification.Name("DidRecieveMovieComments")

//Request movie list data and alert error message in `viewController`.
func requestMovies(viewController: UIViewController) {
    
    let urlString: String = "http://connect-boxoffice.run.goorm.io/movies?order_type=\(OrderType.getOrderType())"
    
    guard let url:URL = URL(string: urlString) else { return }
    
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
        
        if let error = error {
            AlertFailMessage(viewController: viewController, errorMessage: error.localizedDescription)
            return
        }
        
        guard let data = data else { return }
        
        do {
            
           let movies: APIMoviesResponse = try JSONDecoder().decode(APIMoviesResponse.self, from: data)

            NotificationCenter.default.post(name: DidReceiveMoviesNotification, object: nil, userInfo: ["movies": movies.movies])
            
        } catch(let err) {
            AlertFailMessage(viewController: viewController, errorMessage: err.localizedDescription)
        }
    }
    
    dataTask.resume()
}

//request movie information data from server with `id` and alert error message in `viewController`.
func requestMovieInfo(id: String, viewController: UIViewController) {
    
    let urlString: String = "http://connect-boxoffice.run.goorm.io/movie?id=\(id)"
    
    guard let url:URL = URL(string: urlString) else { return }
    
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
        
        if let error = error {
            AlertFailMessage(viewController: viewController, errorMessage: error.localizedDescription)
            return
        }
        
        guard let data = data else { return }
        
        do {
            
            let movieInfo: MovieInfo = try JSONDecoder().decode(MovieInfo.self, from: data)
            
            NotificationCenter.default.post(name: DidReceiveMovieInfoNotification, object: nil, userInfo: ["movie": movieInfo])
            
        } catch(let err) {
            AlertFailMessage(viewController: viewController, errorMessage: err.localizedDescription)
        }
    }
    
    dataTask.resume()
}

//request movie comments data from server with `id` and alert error message in `viewController`.
func requestMovieComments(id: String, viewController: UIViewController) {
    
    let urlString: String = "http://connect-boxoffice.run.goorm.io/comments?movie_id=\(id)"
    
    guard let url:URL = URL(string: urlString) else { return }
    
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
        
        if let error = error {
            AlertFailMessage(viewController: viewController, errorMessage: error.localizedDescription)
            return
        }
        
        guard let data = data else { return }
        
        do {
            
            let comments: APICommentsResponse = try JSONDecoder().decode(APICommentsResponse.self, from: data)
            
            NotificationCenter.default.post(name: DidReceiveMovieCommentsNotification, object: nil, userInfo: ["comments": comments.comments])
            
        } catch(let err) {
            AlertFailMessage(viewController: viewController, errorMessage: err.localizedDescription)
        }
    }
    
    dataTask.resume()
}

//Alert `errorMessage` in `viewController`.
func AlertFailMessage(viewController: UIViewController, errorMessage: String) {
    let actionSheetController: UIAlertController
    actionSheetController = UIAlertController(title: "ERROR!", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
    
    let cancelAction: UIAlertAction
    cancelAction = UIAlertAction(title: "닫기", style: UIAlertActionStyle.cancel, handler: nil)
    
    actionSheetController.addAction(cancelAction)
    
    viewController.present(actionSheetController, animated: true, completion: nil)
}

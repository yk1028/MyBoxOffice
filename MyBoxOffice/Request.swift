//
//  Request.swift
//  MyBoxOffice
//
//  Created by Wongeun Song on 2018. 12. 9..
//  Copyright © 2018년 Wongeun Song. All rights reserved.
//

import UIKit

let DidReceiveMoviesNotification: Notification.Name = Notification.Name("DidRecieveMovies")
let DidReceiveMovieInfoNotification: Notification.Name = Notification.Name("DidRecieveMovieInfo")
let DidReceiveMovieCommentsNotification: Notification.Name = Notification.Name("DidRecieveMovieComments")

//Request movie list data and alert error message in `viewController`.
func requestMovies(completion: @escaping(_ error: Error?) -> () = { _ in }) {
    
    let urlString: String = "http://connect-boxoffice.run.goorm.io/movies?order_type=\(OrderType.orderTypeProperty)"
    
    guard let url:URL = URL(string: urlString) else { return }
    
    let session: URLSession = URLSession(configuration: .default)
    
    DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        if let error = error {
            completion(error)
            return
        }
        
        guard let data = data else { return }
        
        do {
            
           let movies: APIMoviesResponse = try JSONDecoder().decode(APIMoviesResponse.self, from: data)

            NotificationCenter.default.post(name: DidReceiveMoviesNotification, object: nil, userInfo: ["movies": movies.movies])
            
        } catch {
            completion(error)
        }
    }
    
    dataTask.resume()
}

//request movie information data from server with `id` and alert error message in `viewController`.
func requestMovieInfo(id: String, completion: @escaping(_ error: Error?) -> () = { _ in }) {
    
    let urlString: String = "http://connect-boxoffice.run.goorm.io/movie?id=\(id)"
    
    guard let url:URL = URL(string: urlString) else { return }
    
    let session: URLSession = URLSession(configuration: .default)
    
    DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        if let error = error {
            completion(error)
            return
        }
        
        guard let data = data else { return }
        
        do {
            
            let movieInfo: MovieInfo = try JSONDecoder().decode(MovieInfo.self, from: data)
            
            NotificationCenter.default.post(name: DidReceiveMovieInfoNotification, object: nil, userInfo: ["movie": movieInfo])
            
        } catch {
            completion(error)
        }
    }
    
    dataTask.resume()
}

//request movie comments data from server with `id` and alert error message in `viewController`.
func requestMovieComments(id: String, completion: @escaping(_ error: Error?) -> () = { _ in }) {
    
    let urlString: String = "http://connect-boxoffice.run.goorm.io/comments?movie_id=\(id)"
    
    guard let url:URL = URL(string: urlString) else { return }
    
    let session: URLSession = URLSession(configuration: .default)
    
    DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        if let error = error {
            completion(error)
            return
        }
        
        guard let data = data else { return }
        
        do {
            
            let comments: APICommentsResponse = try JSONDecoder().decode(APICommentsResponse.self, from: data)
            
            NotificationCenter.default.post(name: DidReceiveMovieCommentsNotification, object: nil, userInfo: ["comments": comments.comments])
            
        } catch {
            completion(error)
        }
    }
    
    dataTask.resume()
}

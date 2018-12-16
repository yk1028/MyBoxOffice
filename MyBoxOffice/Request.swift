//
//  Request.swift
//  MyBoxOffice
//
//  Created by Wongeun Song on 2018. 12. 9..
//  Copyright © 2018년 Wongeun Song. All rights reserved.
//

import Foundation

let DidReceiveMoviesNotification: Notification.Name = Notification.Name("DidRecieveMovies")
let DidReceiveMovieInfoNotification: Notification.Name = Notification.Name("DidRecieveMovieInfo")
let DidReceiveMovieCommentsNotification: Notification.Name = Notification.Name("DidRecieveMovieComments")

func requestMovies() {
    
    let urlString: String = "http://connect-boxoffice.run.goorm.io/movies?order_type=\(OrderType.getOrderType())"
    
    guard let url:URL = URL(string: urlString) else { return }
    
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let data = data else { return }
        
        do {
            
           let movies: APIMoviesResponse = try JSONDecoder().decode(APIMoviesResponse.self, from: data)

            NotificationCenter.default.post(name: DidReceiveMoviesNotification, object: nil, userInfo: ["movies": movies.movies])
            
        } catch(let err) {
            print(err.localizedDescription)
        }
    }
    
    dataTask.resume()
}

func requestMovieInfo(_ id: String) {
    
    let urlString: String = "http://connect-boxoffice.run.goorm.io/movie?id=\(id)"
    
    guard let url:URL = URL(string: urlString) else { return }
    
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let data = data else { return }
        
        do {
            
            let movieInfo: MovieInfo = try JSONDecoder().decode(MovieInfo.self, from: data)
            
            NotificationCenter.default.post(name: DidReceiveMovieInfoNotification, object: nil, userInfo: ["movie": movieInfo])
            
        } catch(let err) {
            print(err.localizedDescription)
        }
    }
    
    dataTask.resume()
}

func requestMovieComments(_ id: String) {
    
    let urlString: String = "http://connect-boxoffice.run.goorm.io/comments?movie_id=\(id)"
    
    guard let url:URL = URL(string: urlString) else { return }
    
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let data = data else { return }
        
        do {
            
            let comments: APICommentsResponse = try JSONDecoder().decode(APICommentsResponse.self, from: data)
            
            NotificationCenter.default.post(name: DidReceiveMovieCommentsNotification, object: nil, userInfo: ["comments": comments.comments])
            
        } catch(let err) {
            print(err.localizedDescription)
        }
    }
    
    dataTask.resume()
}

//
//  Request.swift
//  MyBoxOffice
//
//  Created by Wongeun Song on 2018. 12. 9..
//  Copyright © 2018년 Wongeun Song. All rights reserved.
//

import Foundation

let DidReceiveMoviesNotification: Notification.Name = Notification.Name("DidRecieveMovies")

func requestMovies() {
    
    guard let url:URL = URL(string: "http://connect-boxoffice.run.goorm.io/comments?movie_id=5a54c286e8a71d136fb5378e") else {
        return
    }
    
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
            
            let movieInfo: MovieInfo = try JSONDecoder().decode(MovieInfo.self, from: data)

            print(movieInfo)
            
//            let comments: APICommentsResponse = try JSONDecoder().decode(APICommentsResponse.self, from: data)
//
//            print(comments.comments)
            
            //NotificationCenter.default.post(name: DidReceiveMoviesNotification, object: nil, userInfo: ["movie": movies.movies])
            
        } catch(let err) {
            print(err.localizedDescription)
        }
    }
    
    dataTask.resume()
}

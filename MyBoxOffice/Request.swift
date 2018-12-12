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
    
    let urlString: String = "http://connect-boxoffice.run.goorm.io/movies?order_type=0"
    
    guard let url:URL = URL(string: urlString) else {
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
            
//            let movieInfo: MovieInfo = try JSONDecoder().decode(MovieInfo.self, from: data)
//
//            print(movieInfo)
            
//            let comments: APICommentsResponse = try JSONDecoder().decode(APICommentsResponse.self, from: data)
//
//            print(comments.comments)
            
        } catch(let err) {
            print(err.localizedDescription)
        }
    }
    
    dataTask.resume()
}

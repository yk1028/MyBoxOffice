//
//  Model.swift
//  MyBoxOffice
//
//  Created by Wongeun Song on 2018. 12. 9..
//  Copyright © 2018년 Wongeun Song. All rights reserved.
//

import Foundation

// 영화 목록
struct APIMoviesResponse: Codable {
    let movies: [Movie]
    let orderType: Int
    
    private enum CodingKeys: String, CodingKey {
        case movies
        case orderType = "order_type"
    }
}

struct Movie: Codable {
    
    let grade: Int
    let thumb: String
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let id: String
    
    var fullInfoInTable: String {
        return "평점 : \(self.userRating) 예매순위 : \(self.reservationGrade) 예매율 : \(self.reservationRate)"
    }
    
    var fullInfoInCollection: String {
        return "\(self.reservationGrade)위(\(self.userRating)) / \(self.reservationRate)%"
    }

    var releaseDate: String {
        return "개봉일 : " + self.date
    }
    
    private enum CodingKeys: String, CodingKey {
        case grade
        case thumb
        case title
        case date
        case id
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}

// 영화 상세정보
struct MovieInfo: Codable {
    let audience: Int
    let actor: String
    let duration: Int
    let director: String
    let synopsis: String
    let genre: String
    let grade: Int //0: 전체이용가 12: 12세 이용가 15: 15세 이용가 19: 19세 이용가
    let image: String
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let id: String
    
    private enum CodingKeys: String, CodingKey {
        case audience, actor, duration
        case director, synopsis, genre
        case grade, image, title
        case date, id
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}

// 한줄평 목록
struct APICommentsResponse: Codable {
    let comments: [Comment]
}

struct Comment: Codable {
    let rating: Double
    let timestamp: Double
    let writer: String
    let movieId: String
    let contents: String
    
    private enum CodingKeys: String, CodingKey {
        case rating,timestamp, writer
        case movieId = "movie_id"
        case contents
    }
}


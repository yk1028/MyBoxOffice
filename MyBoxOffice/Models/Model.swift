//
//  Model.swift
//  MyBoxOffice
//
//  Created by Wongeun Song on 2018. 12. 9..
//  Copyright © 2018년 Wongeun Song. All rights reserved.
//

import Foundation

// MovieList
struct APIMoviesResponse: Codable {
    
    let movies: [Movie]
    let orderType: Int              // 0: 예매율(default) 1: 큐레이션 2: 개봉일
    
    private enum CodingKeys: String, CodingKey {
        case movies
        case orderType = "order_type"
    }
}

struct Movie: Codable {
    
    let grade: Int                  // 관람등급  0: 전체이용가, 12: 12세 이용가, 15: 15세 이용가, 19: 19세 이용가
    let thumb: String               // 포스터 이미지 섬네일 주소
    let reservationGrade: Int       // 예매순위
    let title: String               // 영화제목
    let reservationRate: Double     // 예매율
    let userRating: Double          // 사용자 평점
    let date: String                // 개봉일
    let id: String                  // 영화 고유 아이디
    
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
        case grade, thumb, title, date, id
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}

// Moive information
struct MovieInfo: Codable {
    
    let audience: Int           // 총 관람객 수
    let actor: String           // 배우진
    let duration: Int           // 영화 상영 길이
    let director: String        // 감독
    let synopsis: String        // 줄거리
    let genre: String           // 영화 장르
    let grade: Int              // 관람등급 0: 전체이용가 12: 12세 이용가 15: 15세 이용가 19: 19세 이용가
    let image: String           // 포스터 이미지 주소
    let reservationGrade: Int   // 예매순위
    let title: String           // 영화제목
    let reservationRate: Double // 예매율
    let userRating: Double      // 사용자 평점
    let date: String            // 개봉일
    let id: String              // 영화 고유 아이디
    
    var genreAndDuration: String {
        return "\(self.genre)/\(self.duration)분"
    }
    
    var reservationInfo: String {
        return "\(self.reservationGrade)위 \(self.reservationRate)%"
    }
    
    private enum CodingKeys: String, CodingKey {
        case audience, actor, duration, director, synopsis, genre, grade, image, title, date, id
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}

// movie comments
struct APICommentsResponse: Codable {
    
    let comments: [Comment]
}

// movie comment
struct Comment: Codable {
    
    let rating: Double      // 평점
    let timestamp: Double   // 작성일시 UNIX Timestamp 값
    let writer: String      // 작성자
    let movieId: String     // 영화 고유ID
    let contents: String    // 한줄평 내용
    
    private enum CodingKeys: String, CodingKey {
        case rating,timestamp, writer, contents
        case movieId = "movie_id"
    }
}


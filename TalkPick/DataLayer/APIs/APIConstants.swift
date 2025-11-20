//
//  APIConstants.swift
//  TalkPick
//
//  Created by jaegu park on 11/3/25.
//

import Foundation

enum APIConstants {
    case kakaoLogin
    case appleLogin
    case myProfile
    case likedTopics
    case logOut
    
    case topicLike(Int)
    case topicDetail(Int)
    case topicToday
    case topicCategory
    
}

extension APIConstants {
    
    static let baseURL = "http://talkpick.co.kr:8080/api/v1"
    
    static func makeEndPoint(_ endpoint: String) -> String {
        baseURL + endpoint
    }
    
    var path: String {
        switch self {
        case .kakaoLogin:
            return APIConstants.makeEndPoint("/members/kakao/login")
        case .appleLogin:
            return APIConstants.makeEndPoint("/members/apple/login")
        case .myProfile:
            return APIConstants.makeEndPoint("/members/me")
        case .likedTopics:
            return APIConstants.makeEndPoint("/members/liked-topics")
        case .logOut:
            return APIConstants.makeEndPoint("/members/logout")
            
        case .topicLike(let topicId):
            return APIConstants.makeEndPoint("/topic/\(topicId)/like")
        case .topicDetail(let topicId):
            return APIConstants.makeEndPoint("/topic/\(topicId)")
        case .topicToday:
            return APIConstants.makeEndPoint("/topic/today-topics")
        case .topicCategory:
            return APIConstants.makeEndPoint("/topic/categories")
        }
    }
}

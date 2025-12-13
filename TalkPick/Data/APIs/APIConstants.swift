//
//  APIConstants.swift
//  TalkPick
//
//  Created by jaegu park on 11/3/25.
//

import Foundation

enum APIConstants {
    case tokenRefresh
    case term
    case kakaoLogin
    case appleLogin
    case signUp
    case myProfile
    case likedTopics
    case logOut
    
    case topicLike(Int)
    case topicDetail(Int)
    case topicToday
    case topicCategory
    
    case randomTotalRecord(Int)
    case randomRate(Int)
    case randomQuit(Int)
    case randomEnd(Int)
    case randomComment(Int)
    case randomStart
    case randomTopics(Int)
}

extension APIConstants {
    
    static let baseURL = "http://talkpick.co.kr:8080/api/v1"
    
    static func makeEndPoint(_ endpoint: String) -> String {
        baseURL + endpoint
    }
    
    var path: String {
        switch self {
        case .tokenRefresh:
            return APIConstants.makeEndPoint("/members/token/refresh")
        case .term:
            return APIConstants.makeEndPoint("/members/term")
        case .kakaoLogin:
            return APIConstants.makeEndPoint("/members/kakao/login")
        case .appleLogin:
            return APIConstants.makeEndPoint("/members/apple/login")
        case .signUp:
            return APIConstants.makeEndPoint("/members/signup")
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
            
        case .randomTotalRecord(let id):
            return APIConstants.makeEndPoint("/random/\(id)/total-record")
        case .randomRate(let id):
            return APIConstants.makeEndPoint("/random/\(id)/rate")
        case .randomQuit(let id):
            return APIConstants.makeEndPoint("/random/\(id)/quit")
        case .randomEnd(let id):
            return APIConstants.makeEndPoint("/random/\(id)/end")
        case .randomComment(let id):
            return APIConstants.makeEndPoint("/random/\(id)/comment")
        case .randomStart:
            return APIConstants.makeEndPoint("/random/start")
        case .randomTopics(let id):
            return APIConstants.makeEndPoint("/random/\(id)/topics")
        }
    }
}

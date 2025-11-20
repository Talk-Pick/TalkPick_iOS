//
//  User.swift
//  TalkPick
//
//  Created by jaegu park on 11/8/25.
//

import Foundation

struct User: Codable {
    let memberId: Int
    let role: String
    let accessToken: String
    let refreshToken: String
    let accessExpiredTime: Int64
    let refreshExpiredTime: Int64
}

struct Profile: Codable {
    let nickname: String
    let profileImgUrl: String
    let gender: String
    let mbti: String?
}

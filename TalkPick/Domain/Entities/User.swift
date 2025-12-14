
import Foundation

struct Token: Codable {
    let memberId: Int
    let role: String
    let accessToken: String
    let accessExpiredTime: Int64
}

struct Term: Codable {
    let memberId: Int
    let message: String
    let talkPickStatus: String
}

struct SignUp: Codable {
    let memberId: Int
    let nickname: String
    let mbti: String?
}

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
    let mbti: String?
}

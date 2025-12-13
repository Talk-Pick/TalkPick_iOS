
import Foundation

struct APIResponse<T: Codable>: Codable {
    let status: String
    let message: String
    let timestamp: String
    let httpStatus: Int
    let data: T
}

struct Response: Codable {
    let status: String
    let message: String
    let timestamp: String
    let httpStatus: Int
}

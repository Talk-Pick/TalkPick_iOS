//
//  APIResponse.swift
//  TalkPick
//
//  Created by jaegu park on 11/8/25.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let status: String
    let message: String
    let timestamp: String
    let httpStatus: Int
    let data: T
}

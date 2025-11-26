//
//  Topic.swift
//  TalkPick
//
//  Created by jaegu park on 11/3/25.
//

import Foundation

struct Topic: Codable {
    let topicId: Int
    let title: String
    let averageTalkTime: Int
    let selectCount: Int
    let category: String
    let keywordName: String
    let keywordIconUrl: String
}

struct TopicDetail: Codable {
    let topicId: Int
    let title: String
    let detail: String
    let category: String
    let categoryGroup: String
    let keywordName: String
    let keywordImageUrl: String
    let topicImageUrl: String
}

struct LikedTopic: Codable {
    let items: LikedDetail
    let hasNext: Bool
    let nextCursor: Cursor
}

struct LikedDetail: Codable {
    let id: Int
    let title: String
    let averageTalkTime: Int
    let selectCount: Int
    let keyword: String
    let category: CategoryDetail
    let createdDate: String
}

struct CategoryDetail: Codable {
    let id: Int
    let title: String
    let description: String
    let imageUrl: String
    let categoryGroup: String
}

struct Cursor: Codable {
    let createdDate: String
    let id: Int
}

//
//  Topic.swift
//  TalkPick
//
//  Created by jaegu park on 11/3/25.
//

import UIKit

struct Topic: Codable {
    let topicId: Int
    let title: String
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

struct TopicModel {
    let id: String
    let tagTitle: String     // 카드 상단 #만약에, #연애 …
    let title: String        // 카드 하단 “MBTI 야구 게임” 등
    let color: UIColor
    let textColor: UIColor
    let imageName: String
}

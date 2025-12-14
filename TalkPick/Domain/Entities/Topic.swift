
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
    let items: [LikedDetail]
    let hasNext: Bool
    let nextCursor: Cursor?
}

struct LikedDetail: Codable {
    let id: Int
    let title: String
    let keyword: String
    let category: CategoryDetail
    let createdDate: String
}

struct CategoryDetail: Codable {
    let id: Int
    let title: String
    let imageUrl: String
    let categoryGroup: String
}

struct Cursor: Codable {
    let createdAt: String
    let id: Int
}

struct RandomId: Codable {
    let randomId: Int
}

struct RandomTopic: Codable {
    let order: Int
    let randomTopicDetails: [RandomTopicDetail]
}

struct RandomTopicDetail: Codable {
    let topicId: Int
    let title: String
    let detail: String
    let categoryGroup: String
    let category: String
    let keywordName: String
    let keywordImageUrl: String
    let keywordIconUrl: String
}

struct TotalRecord: Codable {
    let topicId: Int
    let order: Int
    let startAt: String  // ISO8601 형식: "2025-12-14T16:44:37.554Z"
    var endAt: String?   // ISO8601 형식: "2025-12-14T16:44:37.554Z"
}

struct TopicModel {
    let id: String
    let keyword: String
    let category: String
    let keywordColor: UIColor
    let categoryColor: UIColor
    let imageName: String
}

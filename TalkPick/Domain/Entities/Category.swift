
import UIKit

struct Category: Codable {
    let categoryId: Int
    let title: String
    let imageUrl: String
    let color: String
}

struct CategoryStyle {
    let bgColor: UIColor
    let textColor: UIColor
    let imageName: String
}

let categoryStyles: [String: CategoryStyle] = [
    "소개팅": CategoryStyle(bgColor: .pink50, textColor: .pink100, imageName: "talkpick_situation1"),
    "그룹 첫 모임": CategoryStyle(bgColor: .yellow50, textColor: .yellow100, imageName: "talkpick_situation2"),
    "아이스브레이킹": CategoryStyle(bgColor: .green50, textColor: .green100, imageName: "talkpick_situation3"),
    "학교": CategoryStyle(bgColor: .blue10, textColor: .blue30, imageName: "talkpick_situation4"),
    "가족": CategoryStyle(bgColor: .purple50, textColor: .purple100, imageName: "talkpick_situation5"),
    "친구": CategoryStyle(bgColor: .orange50, textColor: .orange100, imageName: "talkpick_situation6"),
    "연인": CategoryStyle(bgColor: .pink10, textColor: .pink30, imageName: "talkpick_situation7"),
    "동료": CategoryStyle(bgColor: .blue50, textColor: .blue100, imageName: "talkpick_situation8"),
]

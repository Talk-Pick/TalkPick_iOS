
import Foundation

extension Date {
    /// Date를 ISO8601 형식의 문자열로 변환
    /// 예: "2025-12-14T16:44:37.554Z"
    func toISO8601String() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }
}

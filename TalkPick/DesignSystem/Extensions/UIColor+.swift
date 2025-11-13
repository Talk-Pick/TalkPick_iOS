//
//  UIColor+.swift
//  TalkPick
//
//  Created by jaegu park on 10/4/25.
//

import UIKit

extension UIColor {
    // 회색
    static let gray10 = UIColor(hexCode: "F9F9F9")
    static let gray50 = UIColor(hexCode: "FAF9F9")
    static let gray100 = UIColor(hexCode: "AEAEAE")
    static let gray200 = UIColor(hexCode: "767676")
    
    // 노랑색
    static let yellow50 = UIColor(hexCode: "FFF3B2")
    static let yellow100 = UIColor(hexCode: "DDBB27")
    
    // 분홍색
    static let pink10 = UIColor(hexCode: "FFD7F2")
    static let pink30 = UIColor(hexCode: "F767C7")
    static let pink50 = UIColor(hexCode: "FFD7DD")
    static let pink100 = UIColor(hexCode: "FF8698")
    
    // 파랑색
    static let blue10 = UIColor(hexCode: "D8F5FD")
    static let blue30 = UIColor(hexCode: "66C4D4")
    static let blue50 = UIColor(hexCode: "D7E5FF")
    static let blue100 = UIColor(hexCode: "66A1EE")
    
    // 초록색
    static let green50 = UIColor(hexCode: "D5F9BA")
    static let green100 = UIColor(hexCode: "7BBA45")
    
    // 보라색
    static let purple50 = UIColor(hexCode: "DDD3FF")
    static let purple100 = UIColor(hexCode: "8E7BFF")
    
    // 주황색
    static let orange50 = UIColor(hexCode: "FFD4B0")
    static let orange100 = UIColor(hexCode: "FF9640")
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

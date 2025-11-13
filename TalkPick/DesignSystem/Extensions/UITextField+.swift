//
//  UITextField+.swift
//  TalkPick
//
//  Created by jaegu park on 10/31/25.
//

import UIKit

public extension UITextField {
    
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func errorfix() {
        self.autocorrectionType = .no
        self.spellCheckingType = .no
    }
}

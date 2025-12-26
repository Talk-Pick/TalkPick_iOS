
import UIKit

extension UIButton {
    
    /// 텍스트 버튼에 눌림 효과를 적용합니다
    func applyTextButtonPressEffect() {
        addTarget(self, action: #selector(handleTouchDown), for: [.touchDown, .touchDragInside])
        addTarget(self, action: #selector(handleTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragOutside])
    }
    
    @objc private func handleTouchDown() {
        // 햅틱 피드백 추가
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: {
                self.alpha = 0.8
                self.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
                if self.layer.shadowOpacity > 0 {
                    self.layer.shadowOpacity = 0.1
                }
            }
        )
    }
    
    @objc private func handleTouchUp() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: {
                self.alpha = 1.0
                self.transform = .identity
                if self.layer.shadowOpacity > 0 {
                    self.layer.shadowOpacity = 0.2
                }
            }
        )
    }
}
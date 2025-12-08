//
//  ServiceView.swift
//  TalkPick
//
//  Created by jaegu park on 12/7/25.
//

import UIKit
import SnapKit

class ServiceView: UIView {
    
    private let contentView: UIView = {
        let uv = UIView()
        uv.backgroundColor = .gray10
        uv.layer.cornerRadius = 20
        return uv
    }()
    
    private let character: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "talkpick_stop"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let cautionLabel: UILabel = {
        let lb = UILabel()
        lb.text = "서비스 준비중입니다"
        lb.font = .systemFont(ofSize: 16, weight: .bold)
        lb.textColor = .black
        return lb
    }()
    
    private let cancelButton: UIButton = {
        let cb = UIButton(type: .system)
        cb.layer.cornerRadius = 12
        cb.backgroundColor = .black
        cb.setTitleColor(.white, for: .normal)
        cb.setTitle("확인", for: .normal)
        cb.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        return cb
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(white: 0, alpha: 0.2)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(contentView)
        contentView.addSubview(character)
        contentView.addSubview(cautionLabel)
        contentView.addSubview(cancelButton)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(80)
            $0.height.equalTo(260)
        }
        
        character.snp.makeConstraints {
            $0.top.equalToSuperview().offset(39)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(97)
        }

        cautionLabel.snp.makeConstraints {
            $0.top.equalTo(character.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(33)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(cautionLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(33)
            $0.height.equalTo(35)
        }
        
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc private func dismissView() {
       UIView.animate(withDuration: 0.3, animations: {
          self.alpha = 0
       }) { _ in
          self.removeFromSuperview()
       }
    }
}

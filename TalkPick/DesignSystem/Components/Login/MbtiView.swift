//
//  MbtiView.swift
//  TalkPick
//
//  Created by jaegu park on 12/1/25.
//

import UIKit
import SnapKit

class MbtiView: UIView {
    
    private let mbtiImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "talkpick_mbtiLogo")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "당신의 MBTI는 무엇인가요?"
        lb.font = .systemFont(ofSize: 22, weight: .heavy)
        lb.textAlignment = .center
        return lb
    }()
    
    private let eBtn = MbtiButton(mainTitle: "E", subTitle: "외향적 (Extraversion)")
    private let iBtn = MbtiButton(mainTitle: "I", subTitle: "내향적 (Introversion)")
    
    private let sBtn = MbtiButton(mainTitle: "S", subTitle: "감각적 (Sensing)")
    private let nBtn = MbtiButton(mainTitle: "N", subTitle: "직관적 (Intuition)")
    
    private let tBtn = MbtiButton(mainTitle: "T", subTitle: "사고형 (Thinking)")
    private let fBtn = MbtiButton(mainTitle: "F", subTitle: "감정형 (Feeling)")
    
    private let jBtn = MbtiButton(mainTitle: "J", subTitle: "판단형 (Judging)")
    private let pBtn = MbtiButton(mainTitle: "P", subTitle: "인식형 (Perceiving)")
    
    let startButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("시작하기", for: .normal)
        bt.layer.borderWidth = 1
        bt.layer.cornerRadius = 12
        bt.isEnabled = false
        bt.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return bt
    }()
    
    private var selectedEI: String?
    private var selectedSN: String?
    private var selectedTF: String?
    private var selectedJP: String?
    
    private var currentMBTI: String? {
        guard let a = selectedEI, let b = selectedSN, let c = selectedTF, let d = selectedJP else { return nil }
        return a + b + c + d
    }
    
    private let startEnabledBG  = UIColor.black
    private let startEnabledFG  = UIColor.white
    private let startDisabledBG = UIColor.white
    private let startDisabledFG = UIColor.gray200
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupLayout() {
        addSubview(mbtiImageView)
        mbtiImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(132)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(16)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mbtiImageView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(30)
        }
        
        [eBtn,iBtn,sBtn,nBtn,tBtn,fBtn,jBtn,pBtn].forEach {
            $0.snp.makeConstraints { $0.height.equalTo(79) }
        }
        
        let row1 = horizontalRow(left: eBtn, right: iBtn)
        let row2 = horizontalRow(left: sBtn, right: nBtn)
        let row3 = horizontalRow(left: tBtn, right: fBtn)
        let row4 = horizontalRow(left: jBtn, right: pBtn)
        
        let vstack = UIStackView(arrangedSubviews: [row1,row2,row3,row4])
        vstack.axis = .vertical
        vstack.alignment = .fill
        vstack.distribution = .fillEqually
        vstack.spacing = 25
        
        addSubview(vstack)
        vstack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(38)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        addSubview(startButton)
        startButton.backgroundColor = startDisabledBG
        startButton.setTitleColor(startDisabledFG, for: .normal)
        startButton.layer.borderColor = startDisabledFG.cgColor
        startButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(vstack.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(85)
            $0.height.equalTo(51)
            $0.bottom.equalToSuperview().inset(160)
        }
    }
    
    private func horizontalRow(left: UIView, right: UIView) -> UIStackView {
        let h = UIStackView(arrangedSubviews: [left, right])
        h.axis = .horizontal
        h.alignment = .fill
        h.spacing = 16
        h.distribution = .fillEqually
        return h
    }
    
    private func bind() {
        // 탭 제스처(UIButton이 아니므로)
        eBtn.addTarget(self, action: #selector(tapEI(_:)), for: .touchUpInside)
        iBtn.addTarget(self, action: #selector(tapEI(_:)), for: .touchUpInside)
        
        sBtn.addTarget(self, action: #selector(tapSN(_:)), for: .touchUpInside)
        nBtn.addTarget(self, action: #selector(tapSN(_:)), for: .touchUpInside)
        
        tBtn.addTarget(self, action: #selector(tapTF(_:)), for: .touchUpInside)
        fBtn.addTarget(self, action: #selector(tapTF(_:)), for: .touchUpInside)
        
        jBtn.addTarget(self, action: #selector(tapJP(_:)), for: .touchUpInside)
        pBtn.addTarget(self, action: #selector(tapJP(_:)), for: .touchUpInside)
        
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
    }
    
    @objc private func tapEI(_ sender: MbtiButton) {
        eBtn.isSelected = (sender === eBtn)
        iBtn.isSelected = (sender === iBtn)
        selectedEI = eBtn.isSelected ? "E" : (iBtn.isSelected ? "I" : nil)
        updateStartButton()
    }
    
    @objc private func tapSN(_ sender: MbtiButton) {
        sBtn.isSelected = (sender === sBtn)
        nBtn.isSelected = (sender === nBtn)
        selectedSN = sBtn.isSelected ? "S" : (nBtn.isSelected ? "N" : nil)
        updateStartButton()
    }
    
    @objc private func tapTF(_ sender: MbtiButton) {
        tBtn.isSelected = (sender === tBtn)
        fBtn.isSelected = (sender === fBtn)
        selectedTF = tBtn.isSelected ? "T" : (fBtn.isSelected ? "F" : nil)
        updateStartButton()
    }
    
    @objc private func tapJP(_ sender: MbtiButton) {
        jBtn.isSelected = (sender === jBtn)
        pBtn.isSelected = (sender === pBtn)
        selectedJP = jBtn.isSelected ? "J" : (pBtn.isSelected ? "P" : nil)
        updateStartButton()
    }
    
    private func updateStartButton() {
        let enabled = (currentMBTI != nil)
        startButton.isEnabled = enabled
        
        let bg = enabled ? startEnabledBG : startDisabledBG
        let fg = enabled ? startEnabledFG : startDisabledFG
        
        UIView.animate(withDuration: 0.15) {
            self.startButton.backgroundColor = bg
            self.startButton.setTitleColor(fg, for: .normal)
        }
    }
    
    @objc private func startTapped() {
        guard let mbti = currentMBTI else { return }
        print("선택한 MBTI:", mbti)
        // navigationController?.pushViewController(NextVC(mbti: mbti), animated: true)
    }
    
    // (선택) 외부에서 초기 MBTI를 설정하고 싶을 때 호출
    func preselect(mbti: String) {
        let chars = Array(mbti.uppercased())
        if chars.count == 4 {
            [eBtn, iBtn, sBtn, nBtn, tBtn, fBtn, jBtn, pBtn].forEach { $0.isSelected = false }
            (chars[0] == "E" ? eBtn : iBtn).isSelected = true
            (chars[1] == "S" ? sBtn : nBtn).isSelected = true
            (chars[2] == "T" ? tBtn : fBtn).isSelected = true
            (chars[3] == "J" ? jBtn : pBtn).isSelected = true
            selectedEI = String(chars[0]); selectedSN = String(chars[1])
            selectedTF = String(chars[2]); selectedJP = String(chars[3])
            updateStartButton()
        }
    }
}

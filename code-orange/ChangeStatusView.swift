//
//  ChangeStatusView.swift
//  code-orange
//
//  Created by shani beracha on 16/03/2020.
//

import Foundation
import UIKit

protocol ChagneStatusViewDelegate: class {
  func statusChanged(to: StatusOption)
  func statusChangeDismissed()
}

@objc enum StatusOption: Int {
  case infected = 0
  case notInfected
  case waitingForResults
  case notTested
}

class ChangeStatueView: UIView {
  var currentSelectedOption: StatusOption? = nil
  public weak var delegate: ChagneStatusViewDelegate?
  
  init() {
    super.init(frame: .zero)
    backgroundColor = .white

    addSubview(dismissButton)
    addSubview(mainStackView)
    makeConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func makeConstraints() {
    dismissButton.pinToSuperview(anchors: [.top(0), .leading(32)])
    mainStackView.pinToSuperview(anchors: [.top(40), .bottom(32), .leading(32), .trailing(32)])
  }
  
  private lazy var dismissButton: UIButton = {
    let b = UIButton(type: .custom)
    b.setImage(UIImage(named: "xButton"), for: .normal)
    b.tintColor = .black
    b.translatesAutoresizingMaskIntoConstraints = false
    b.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
    return b
  }()
  
  private lazy var questionMarkButton: UIButton = {
    let b = UIButton(type: .custom)
    b.setTitle("?", for: .normal)
    b.setTitleColor(.purple, for: .normal)
    b.tintColor = .purple
    b.borderColor = .purple
    b.borderWidth = 1
    b.cornerRadius = 12
    b.setAutoLayoutWidth(24)
    b.setAutoLayoutHeight(24)
    b.translatesAutoresizingMaskIntoConstraints = false
    return b
  }()
  
  private lazy var titleLabel: UILabel = {
    let lbl = UILabel(frame: .zero)
    lbl.text = "שנה סטטוס"
    lbl.numberOfLines = 0
    lbl.textAlignment = .natural
    lbl.textColor = .black
    let font = UIFont(name: "OpenSansHebrew-Bold", size: CGFloat(28.0)) ?? UIFont.boldSystemFont(ofSize: 28.0)
    lbl.font = font
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()
  
  private lazy var titleAndButtonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .leading
    stackView.spacing = 16
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(questionMarkButton)
    return stackView
  }()
  
  private lazy var firstButton: UIButton = {
    let b = NormalButton()
    b.setTitle("נבדקתי ואובחנתי כנשא של COVID-19", for: .normal)
    b.translatesAutoresizingMaskIntoConstraints = false
    b.addTarget(self, action: #selector(infectedSelected), for: .touchUpInside)
    return b
  }()
  
  private lazy var secondButton: UIButton = {
    let b = NormalButton()
    b.setTitle("נבדקתי ולא אובחנתי כנשא", for: .normal)
    b.translatesAutoresizingMaskIntoConstraints = false
    b.addTarget(self, action: #selector(notInfectedSelected), for: .touchUpInside)
    return b
  }()
  
  private lazy var thirdButton: UIButton = {
    let b = NormalButton()
    b.setTitle("נבדקתי ומחכה לתשובה", for: .normal)
    b.translatesAutoresizingMaskIntoConstraints = false
    b.addTarget(self, action: #selector(waitingSelected), for: .touchUpInside)
    return b
  }()
  
  private lazy var forthButton: UIButton = {
    let b = NormalButton()
    b.setTitle("לא נבדקתי", for: .normal)
    b.translatesAutoresizingMaskIntoConstraints = false
    b.addTarget(self, action: #selector(notTestedSelected), for: .touchUpInside)
    return b
  }()
  
  private lazy var approveButton: UIButton = {
    let b = ApproveButton()
    b.setTitle("אישור", for: .normal)
    b.translatesAutoresizingMaskIntoConstraints = false
    b.addTarget(self, action: #selector(approveTapped), for: .touchUpInside)
    return b
  }()
  
  private lazy var allButtons = [firstButton, secondButton, thirdButton, forthButton]
  
  private lazy var mainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.addArrangedSubview(titleAndButtonStackView)
    stackView.addArrangedSubview(firstButton)
    stackView.addArrangedSubview(secondButton)
    stackView.addArrangedSubview(thirdButton)
    stackView.addArrangedSubview(forthButton)
    stackView.addArrangedSubview(approveButton)
    stackView.spacing = 16
    return stackView
  }()
  
  @objc private func infectedSelected() {
    optionSelected(option: .infected)
  }
  
  @objc private func notInfectedSelected() {
    optionSelected(option: .notInfected)
  }
  
  @objc private func waitingSelected() {
    optionSelected(option: .waitingForResults)
  }
  
  @objc private func notTestedSelected() {
    optionSelected(option: .notTested)
  }
  
  @objc private func optionSelected(option: StatusOption) {
    defer {
      currentSelectedOption = option
      allButtons[option.rawValue].borderColor = .black
    }
    
    guard let currentSelectedOption = currentSelectedOption else {
      return
    }
    
    allButtons[currentSelectedOption.rawValue].borderColor = .white
  }
  
  @objc private func approveTapped() {
    guard let currentSelectedOption = currentSelectedOption else {
      // do we need an alert to the user here?
      return
    }
    
    delegate?.statusChanged(to: currentSelectedOption)
  }
  
  @objc private func dismissTapped() {
    delegate?.statusChangeDismissed()
  }
}



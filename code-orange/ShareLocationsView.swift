//
//  ShareLocationsViewController.swift
//  code-orange
//
//  Created by shani beracha on 17/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation
import UIKit

protocol ShareLocationViewDelegate: class {
  func shareLocationsDismissed(_ sender: UIView)
  func shareLocationApproved(_ sender: UIView, code: String)
}

class ShareLocationView: UIView {
  public weak var delegate: ShareLocationViewDelegate?
  
  init() {
    super.init(frame: .zero)
    backgroundColor = .white

    addSubview(dismissButton)
    addSubview(mainStackView)
    addSubview(approveButton)
    makeConstraints()
    setupTapGestureRecognizer()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func makeConstraints() {
    dismissButton.pinToSuperview(anchors: [.top(76), .leading(32)])
    mainStackView.position(below: dismissButton, constant: 8)
    mainStackView.pinToSuperview(anchors: [.leading(32), .trailing(32)])
    approveButton.pinToSuperview(anchors: [.bottom(32), .leading(32), .trailing(32)])
    textField.pinToSuperview(anchors: [.trailing(0), .leading(0)])
  }
  
  private func setupTapGestureRecognizer() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                      action: #selector(dismissKeyboard))
    tapGestureRecognizer.cancelsTouchesInView = false
    tapGestureRecognizer.delegate = self
    addGestureRecognizer(tapGestureRecognizer)
  }
  
  private lazy var dismissButton: UIButton = {
    let b = UIButton(type: .custom)
    b.setImage(UIImage(named: "xButton"), for: .normal)
    b.tintColor = .black
    b.translatesAutoresizingMaskIntoConstraints = false
    b.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
    return b
  }()
  
  private lazy var locationsImage: UIImageView = {
    let imageView = UIImageView(frame: .zero)
    imageView.image = UIImage(named: "shareLocations")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .center
    imageView.setAutoLayoutHeight(112)
    imageView.setSquareRatio()
    return imageView
  }()
  
  private lazy var firstLabel: UILabel = {
    let lbl = UILabel(frame: .zero)
    lbl.text = "שתפו את המקומות בהם שהיתם עם משרד הבריאות כדי שניתן יהיה לאתר במהירות חולים נוספים.\n\nכדי לשתף יש להכניס את קוד האימות שקיבלתם עם תוצאות הבדיקה"
    lbl.numberOfLines = 0
    lbl.lineBreakMode = .byWordWrapping
    lbl.textAlignment = .natural
    lbl.textColor = .black
    let font = UIFont(name: "OpenSansHebrew-Regular", size: CGFloat(16.0)) ?? UIFont.systemFont(ofSize: 20.0)
    lbl.font = font
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()
  
  private lazy var secondLabel: UILabel = {
      let lbl = UILabel(frame: .zero)
      lbl.text = "*חשוב להדגיש שלאפליקציית צבע כתום אין גישה בשום שלב לפרטי הזיהוי של המשתמשים"
      lbl.numberOfLines = 0
      lbl.lineBreakMode = .byWordWrapping
      lbl.textAlignment = .natural
      lbl.textColor = .black
      let font = UIFont(name: "OpenSansHebrew-Regular", size: CGFloat(16.0)) ?? UIFont.systemFont(ofSize: 20.0)
      lbl.font = font
      lbl.translatesAutoresizingMaskIntoConstraints = false
      return lbl
    }()
  
  private lazy var textField: UITextField = {
    let textField = CodeOrangeTextField()
    textField.placeholder = "הכנס קוד ממשרד הבריאות"
    textField.delegate = self
    return textField
  }()
  
  private lazy var mainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .equalSpacing
    stackView.addArrangedSubview(locationsImage)
    stackView.addArrangedSubview(firstLabel)
    stackView.addArrangedSubview(textField)
    stackView.addArrangedSubview(secondLabel)
    stackView.spacing = 24
    return stackView
  }()
  
  private lazy var approveButton: UIButton = {
    let b = ApproveButton()
    b.setTitle("שתף עם משרד הבריאות", for: .normal)
    b.translatesAutoresizingMaskIntoConstraints = false
    let font = UIFont(name: "OpenSansHebrew-Regular", size: CGFloat(14.0)) ?? UIFont.boldSystemFont(ofSize: 18.0)
    b.titleLabel?.font =  font
    b.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
    return b
  }()
  
  @objc private func dismissTapped() {
    delegate?.shareLocationsDismissed(self)
  }
  
  @objc private func shareTapped() {
    // add more verification here
    guard let enteredText = textField.text else {
      print("Cant continue with no text")
      return
    }
    
    print("sharing: \(enteredText)")
    delegate?.shareLocationApproved(self, code: enteredText)
  }
}

extension ShareLocationView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    dismissKeyboard()
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.text = ""
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    // add verification here
  }
  
  @objc func dismissKeyboard() {
    endEditing(true)
  }
}

extension ShareLocationView: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return touch.view == self || touch.view == mainStackView
  }
}

class CodeOrangeTextField: UITextField {
  init() {
    super.init(frame: .zero)
    setAutoLayoutHeight(52)
    let fontToUse = UIFont(name: "OpenSansHebrew-Regular", size: CGFloat(16.0)) ?? UIFont.systemFont(ofSize: 20.0)
    font = fontToUse
    textAlignment = .natural
    borderColor = .orange
    borderWidth = 2
    cornerRadius = 8
    keyboardType = .numberPad
    // this doesnt wotk with numPad. add button instead
    returnKeyType = .continue
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: 10, dy: 10)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: 10, dy: 10)
  }
}

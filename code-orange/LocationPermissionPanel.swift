//
//  LocationPermissionPanel.swift
//  code-orange
//
//  Created by Renen Elal on 17/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation
import UIKit

protocol LocationPermissionPanelDelegate: class {
  func locationPermissionAuthorized()
  func locationPermissionNotAuthorized()
  func locationPermissionMaximized()
}

class LocationPermissionPanel: UIView {
  
  public static var didShow: Bool {
    get {
      return UserDefaults.standard.bool(forKey: "LocationPermissionPanel.didShow")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "LocationPermissionPanel.didShow")
    }
  }
  
  public weak var delegate: LocationPermissionPanelDelegate?
  public var isMinimized = false {
    didSet {
      titleButton.titleLabel?.font = .systemFont(ofSize: isMinimized ? 14 : 24)
      bodyLabel.text = isMinimized ? compactText : fullText
      yesButton.setTitle(isMinimized ? approveCompactText : approveText, for: .normal)
      noButton.isHidden = isMinimized
    }
  }
  
  private let fullText = "- בכדי שנוכל להצליב את מיקומיך עם רשימת המקומות בהם היו נשאי קורונה, אנא אשר לנו גישה למיקומך.\n\n- מיקומך ידגם בכל 15 דקות והמידע ישמר בצורה מאובטחת אך ורק על הטלפון שלך.\n\n- המידע לא ישלח בצורה אוטומטית לאף אחד, כולל לא למשרד הבריאות.\n\n- אנו נבצע ייבוא של מידע המיקום שלך מהשבועיים האחרונים מ-google maps כדי למצוא עבורך את מירב ההצלבות"
  private let compactText = "בכדי שנוכל להצליב את מיקומיך עם רשימת המקומות בהם היו נשאי קורונה, אנא אשר לנו גישה למיקומך."
  private let approveText = "כן, אני מעוניין"
  private let approveCompactText = "מאשר גישה למיקום"
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    stackView.axis = .vertical
    stackView.spacing = 16
    stackView.addArrangedSubview(titleButton)
    stackView.addArrangedSubview(bodyLabel)
    stackView.addArrangedSubview(yesButton)
    stackView.addArrangedSubview(noButton)
    return stackView
  }()
  
  private lazy var titleButton: UIButton = {
    let button = UIButton()
    button.setTitle("אשר גישה למיקומך", for: .normal)
    button.setTitleColor(.nxGrey90, for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 24)
    button.titleLabel?.textAlignment = .right
    button.addTarget(self, action: #selector(titleTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var bodyLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    label.textColor = .nxGrey90
    label.textAlignment = .right
    label.text = fullText
    return label
  }()
  
  private lazy var yesButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .nxOrange
    button.setTitleColor(.nxGrey90, for: .normal)
    button.setTitle(approveText, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.addTarget(self, action: #selector(yesTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var noButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .nxWhite
    button.borderColor = .nxOrange
    button.borderWidth = 2.0
    button.setTitleColor(.nxGrey90, for: .normal)
    button.setTitle("לא, איני מעוניין כרגע", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.addTarget(self, action: #selector(noTapped), for: .touchUpInside)
    return button

  }()
  
  @objc private func yesTapped() {
    delegate?.locationPermissionAuthorized()
  }
  
  @objc private func noTapped() {
    delegate?.locationPermissionNotAuthorized()
    isMinimized = true
  }
  
  @objc private func titleTapped() {
    guard isMinimized else { return }
    isMinimized = false
    delegate?.locationPermissionMaximized()
  }
  
  init() {
    super.init(frame: .zero)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    addSubview(stackView)
    stackView.fillSuperview()
  }
}

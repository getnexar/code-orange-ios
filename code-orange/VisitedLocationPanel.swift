//
//  VisitedLocationPanel.swift
//  code-orange
//
//  Created by Renen Elal on 16/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation
import UIKit

protocol VisitedLocationsPanelDelegate: class {
  func visitedLocationsPanelCallEmergency()
  func visitedLocationsPanelOpenHealthAdministrationWebsite()
}

class VisitedLocationsPanel: UIView {
  
  public weak var delegate: VisitedLocationsPanelDelegate?
  
  private var locations: [RecordedLocation]

  init(locations: [RecordedLocation]) {
    self.locations = locations
    super.init(frame: .zero)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func commonInit() {
    addSubview(mainStackView)
    mainStackView.fillSuperview()
  }
  
  private lazy var mainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 16
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    stackView.addArrangedSubview(titleAndButtonsStackView)
    stackView.addArrangedSubview(topLabel)
    stackView.addArrangedSubview(bottomLabel)
    stackView.addArrangedSubview(actionsStackView)
    return stackView
  }()
  
  private lazy var titleStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 2
    stackView.alignment = .center
    stackView.addArrangedSubview(pagesLabel)
    stackView.addArrangedSubview(addressLabel)
    stackView.addArrangedSubview(timeframeLabel)
    return stackView
  }()

  private lazy var titleAndButtonsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 2
    stackView.alignment = .center
    stackView.addArrangedSubview(leftPageButton)
    stackView.addArrangedSubview(titleStackView)
    stackView.addArrangedSubview(rightPageButton)
    return stackView
  }()

  private lazy var actionsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 24
    stackView.alignment = .center
    stackView.addArrangedSubview(healthAdministrationWebsiteButton)
    stackView.addArrangedSubview(callEmergencyServiceButton)
    return stackView
  }()

  private lazy var leftPageButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "left"), for: .normal)
    button.addTarget(self, action: #selector(previousLocationTapped), for: .touchUpInside)
    return button
  }()

  private lazy var rightPageButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "right"), for: .normal)
    button.addTarget(self, action: #selector(nextLocationPickedTapped), for: .touchUpInside)
    return button
  }()

  private lazy var pagesLabel: UILabel = {
    let label = UILabel()
    label.text = "1/2"
    return label
  }()

  private lazy var addressLabel: UILabel = {
    let label = UILabel()
    label.text = "שדרות בן גוריון 22, תל אביב"
    return label
  }()

  private lazy var timeframeLabel: UILabel = {
    let label = UILabel()
    
    return label
  }()

  private lazy var topLabel: UILabel = {
    let attributedText = NSMutableAttributedString(string: "ייתכן שנחשפת באזור לוירוס הקורונה.\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
    attributedText.append(NSAttributedString(string: "שים לב, ההודעה אינה אומרת שנדבקת.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
    let label = UILabel()
    label.attributedText = attributedText
    return label
  }()

  private lazy var bottomLabel: UILabel = {
    let attributedText = NSMutableAttributedString(string: "צעדים שכדאי לעשות כרגע:\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "להיכנס לבידוד, ולמדוד את חום הגוף. אם זיהית תסמינים (חום, שיעול יבש) יש לפנות למד״א.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
    let label = UILabel()
    label.attributedText = attributedText
    return label
  }()

  private lazy var healthAdministrationWebsiteButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .nxOrange
    button.setTitleColor(.black, for: .normal)
    button.setTitle("אתר משרד הבריאות", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    button.addTarget(self, action: #selector(healthAdministrationWebsiteButtonTapped), for: .touchUpInside)
    return button
  }()

  private lazy var callEmergencyServiceButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .nxOrange
    button.setTitleColor(.black, for: .normal)
    button.setTitle("התקשר 101", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    button.addTarget(self, action: #selector(callEmergencyServiceButtonTapped), for: .touchUpInside)
    return button
  }()
  
  @objc private func healthAdministrationWebsiteButtonTapped() {
    delegate?.visitedLocationsPanelOpenHealthAdministrationWebsite()
  }
  
  @objc private func callEmergencyServiceButtonTapped() {
    delegate?.visitedLocationsPanelCallEmergency()
  }
  
  @objc private func previousLocationTapped() {
    print("previous location tapped")
  }

  @objc private func nextLocationPickedTapped() {
    print("next location tapped")
  }
}

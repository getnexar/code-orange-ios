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
  func visitedLocationsDidSelectLocation(_ location: CoronaLocation)
}

class VisitedLocationsPanel: UIView {
  
  public weak var delegate: VisitedLocationsPanelDelegate? {
    didSet {
      let selectedLocation = locations[currentLocationIndex].infectedLocation.location
      delegate?.visitedLocationsDidSelectLocation(selectedLocation)
    }
  }
  private var currentLocationIndex = 0
  private var locations: [MatchedLocation]

  init?(locations: [MatchedLocation]) {
    guard !locations.isEmpty else { return nil }
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
    reloadData()
  }
  
  private lazy var mainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 16
    stackView.addArrangedSubview(titleAndButtonsStackViewContainer)
    stackView.addArrangedSubview(topLabelStack)
    stackView.addArrangedSubview(bottomLabelStack)
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

  private lazy var titleAndButtonsStackViewContainer: UIView = {
    let stackView = UIStackView()
    stackView.backgroundColor = .nxGrey10
    stackView.axis = .horizontal
    stackView.spacing = 2
    stackView.alignment = .center
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
    stackView.addArrangedSubview(leftPageButton)
    stackView.addArrangedSubview(titleStackView)
    stackView.addArrangedSubview(rightPageButton)
    let view = UIView()
    view.backgroundColor = .nxGrey10
    view.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.fillSuperview()
    return view
  }()

  private lazy var actionsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 24
    stackView.alignment = .center
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 12, left: 24, bottom: 24, right: 24)
    stackView.addArrangedSubview(healthAdministrationWebsiteButton)
    stackView.addArrangedSubview(callEmergencyServiceButton)
    return stackView
  }()

  private lazy var leftPageButton: UIButton = {
    let button = UIButton()
    button.setImage(getLocalizedImage(image: UIImage(named: "left")), for: .normal)
    button.addTarget(self, action: #selector(previousLocationTapped), for: .touchUpInside)
    return button
  }()

  private lazy var rightPageButton: UIButton = {
    let button = UIButton()
    button.setImage(getLocalizedImage(image: UIImage(named: "right")), for: .normal)
    button.addTarget(self, action: #selector(nextLocationPickedTapped), for: .touchUpInside)
    return button
  }()

  private lazy var pagesLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    return label
  }()

  private lazy var addressLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    return label
  }()
  
  private lazy var timeFormatter: DateFormatter = {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "HH:MM"
    return dateFormater
  }()

  private lazy var timeframeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()

  private lazy var topLabelStack: UIStackView = {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .justified
    paragraphStyle.baseWritingDirection = .rightToLeft
    let attributedText = NSMutableAttributedString(string: "ייתכן שנחשפת באזור לוירוס הקורונה.\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.paragraphStyle: paragraphStyle])
    attributedText.append(NSAttributedString(string: "שים לב, ההודעה אינה אומרת שנדבקת.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.paragraphStyle: paragraphStyle]))
    let label = UILabel()
    label.attributedText = attributedText
    label.numberOfLines = 0
    return HorizontalPaddingStackView(around: label)
  }()

  private lazy var bottomLabelStack: UIStackView = {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .justified
    paragraphStyle.baseWritingDirection = .rightToLeft
    let attributedText = NSMutableAttributedString(string: "צעדים שכדאי לעשות כרגע:\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.paragraphStyle: paragraphStyle])
    attributedText.append(NSAttributedString(string: "להיכנס לבידוד, ולמדוד את חום הגוף. אם זיהית תסמינים (חום, שיעול יבש) יש לפנות למד״א.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.paragraphStyle: paragraphStyle]))
    let label = UILabel()
    label.attributedText = attributedText
    label.numberOfLines = 0
    return HorizontalPaddingStackView(around: label)
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
    currentLocationIndex -= 1
    if currentLocationIndex < 0 {
      currentLocationIndex = locations.count - 1
    }
    delegate?.visitedLocationsDidSelectLocation(locations[currentLocationIndex].infectedLocation.location)
    reloadData()
  }

  @objc private func nextLocationPickedTapped() {
    currentLocationIndex += 1
    if currentLocationIndex >= locations.count {
      currentLocationIndex = 0
    }
    delegate?.visitedLocationsDidSelectLocation(locations[currentLocationIndex].infectedLocation.location)
    reloadData()
  }
  
  private func reloadData() {
    let hasSingleLocation = locations.count < 2
    let currentLocation = locations[currentLocationIndex]
    let startTime = timeFormatter.string(from: currentLocation.userLocation.startTime)
    let endTime = timeFormatter.string(from: currentLocation.userLocation.endTime)
    timeframeLabel.text = "\(startTime) - \(endTime)"
    pagesLabel.text = "\(currentLocationIndex + 1)/\(locations.count)"
    leftPageButton.isHidden = hasSingleLocation
    rightPageButton.isHidden = hasSingleLocation
    pagesLabel.isHidden = hasSingleLocation
    addressLabel.text = currentLocation.infectedLocation.address ?? currentLocation.userLocation.address
  }
}

private class HorizontalPaddingStackView: UIStackView {
  init(around view: UIView) {
    super.init(frame: .zero)
    let padding = UIView()
    padding.setAutoLayoutWidth(24)
    let padding2 = UIView()
    padding2.setAutoLayoutWidth(24)
    axis = .horizontal
    addArrangedSubview(padding)
    addArrangedSubview(view)
    addArrangedSubview(padding2)
  }
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UIView {
  func getLocalizedImage(image: UIImage?) -> UIImage? {
    if UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft {
      return image?.imageFlippedForRightToLeftLayoutDirection()
    } else {
      return image
    }
  }
}

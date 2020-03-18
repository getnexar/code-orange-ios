//
//  InfectedLocationView.swift
//  code-orange
//
//  Created by shani beracha on 18/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation
import UIKit

class InfectedLocationView: UIView {
  var startTime: Date
  var endTime: Date
  var address: String?
  
  init(startTime: Date, endTime: Date, address: String?) {
    self.startTime = startTime
    self.endTime = endTime
    self.address = address
    super.init(frame: .zero)
    backgroundColor = .white
    
    addSubview(stackView)
    stackView.pinToSuperview(anchors: [.top(16), .leading(20), .trailing(20)])
    if #available(iOS 11, *) {
      stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    } else {
      stackView.pinToSuperview(anchors: [.bottom(16)])
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var timeFormatter: DateFormatter = {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "HH:mm"
    return dateFormater
  }()
  
  private lazy var timeLabel: UILabel = {
    let lbl = UILabel(frame: .zero)
    lbl.text = getCodeOrangeFullDateString(startTime: startTime, endTime: endTime)
    lbl.numberOfLines = 0
    lbl.textAlignment = .natural
    lbl.textColor = .nxGrey70
    let font = UIFont(name: "OpenSansHebrew-Regular", size: CGFloat(14.0)) ?? UIFont.systemFont(ofSize: 15.0)
    lbl.font = font
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()
  
  private lazy var addressLabel: UILabel = {
    let lbl = UILabel(frame: .zero)
    lbl.text = address
    lbl.numberOfLines = 0
    lbl.textAlignment = .natural
    lbl.textColor = .nxGrey90
    let font = UIFont(name: "OpenSansHebrew-Bold", size: CGFloat(16.0)) ?? UIFont.boldSystemFont(ofSize: 18.0)
    lbl.font = font
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.addArrangedSubview(timeLabel)
    stackView.addArrangedSubview(addressLabel)
    stackView.spacing = 5
    return stackView
  }()
}

extension Date {
  var weekday: Weekday? {
    let myCalendar = Calendar(identifier: .gregorian)
    let weekDay = myCalendar.component(.weekday, from: self)
    return Weekday(rawValue: weekDay)
  }
}

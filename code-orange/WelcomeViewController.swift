//
//  WelcomeViewController.swift
//  code-orange
//
//  Created by Renen Elal on 17/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController: UIViewController {
  
  public static var didShow: Bool {
    get {
      return UserDefaults.standard.bool(forKey: "WelcomeViewController.didShow")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "WelcomeViewController.didShow")
    }
  }
  
  lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 24
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(subtitleLabel)
    stackView.addArrangedSubview(bodyLabel)
    stackView.addArrangedSubview(UIView())
    stackView.addArrangedSubview(nextButton)
    return stackView
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 24)
    label.text = "ברוך הבא לצבע כתום"
    label.textAlignment = .right
    label.textColor = .nxGrey90
    label.numberOfLines = 0
    return label
  }()
  
  lazy var subtitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.text = "האפליקציה שתעזור לכולנו לעצור את התפשטות וירוס הקורונה בישראל."
    label.textAlignment = .right
    label.textColor = .nxGrey90
    label.numberOfLines = 0
    return label
  }()

  lazy var bodyLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.text = "האפליקציה מציגה לך דיווחים מאומתים של מיקומים וזמנים בהם היו חולי קורונה.\nהאפליקציה גם מאפשרת לך לשמור על מכשירך בצורה מאובטחת את רשימת המקומות בהם אתה ביקרת, ולהצליב עבורך את אותם מקומות עם המקומות המדווחים כדי שתוכל לדעת אם אתה בקבוצת הסיכון ולפעול בהתאם."
    label.textAlignment = .right
    label.textColor = .nxGrey90
    label.numberOfLines = 0
    return label
  }()
  
  lazy var nextButton: UIButton = {
    let button = UIButton()
    button.setTitle("הבא", for: .normal)
    button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    button.setAutoLayoutHeight(52)
    button.backgroundColor = .nxOrange
    button.setTitleColor(.nxGrey90, for: .normal)
    button.clipsToBounds = true
    button.layer.cornerRadius = 8
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(stackView)
    stackView.fillSuperview()
  }
  
  @objc private func nextTapped() {
    WelcomeViewController.didShow = true
    let vc = MainViewController()
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true, completion: nil)
  }
}

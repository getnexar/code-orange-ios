//
//  DrawerView.swift
//  code-orange
//
//  Created by Renen Elal on 16/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation
import UIKit

class DrawerView: UIView {
  
  public var contentView: UIView? {
    set {
      self.contentView?.removeFromSuperview()
      guard let contentView = newValue else { return }
      install(contentView)
    }
    get {
      return containerView.subviews.last
    }
  }
  
  private lazy var containerView: UIView = {
    let view = UIView()
    view.layer.masksToBounds = true
    view.layer.cornerRadius = 24
    view.backgroundColor = .white
    return view
  }()
  
  init() {
    super.init(frame: .zero)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.cornerRadius = 24
    layer.shadowOpacity = 0.5
    layer.shadowOffset = .zero
    layer.shadowRadius = 12
    addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.fillSuperview()
  }
  
  private func install(_ contentView: UIView) {
    containerView.addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.pinToSuperview(anchors: [.top(0), .leading(0), .trailing(0), .bottom(24)])
  }
}

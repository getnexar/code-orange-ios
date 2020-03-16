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
      self.hidingConstraint?.isActive = false
      guard let contentView = newValue else { return }
      install(contentView)
    }
    get {
      return subviews.first
    }
  }
  
  public func show() {
    alpha = 1 // TODO: use hiding constraint
  }
  
  public func hide() {
    alpha = 0 // TODO: use hiding constraint
  }
  
  private var hidingConstraint: NSLayoutConstraint?
  
  init() {
    super.init(frame: .zero)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    layer.masksToBounds = true
    layer.cornerRadius = 24
    backgroundColor = .white
    alpha = 0 // TODO: use hiding constraint
  }
  
  private func install(_ contentView: UIView) {
    addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.pinToSuperview(anchors: [.leading(0), .trailing(0)])
    let topContraint = contentView.topAnchor.constraint(equalTo: topAnchor, constant: 24)
    topContraint.isActive = true
    let bottomContraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
    bottomContraint.isActive = true
    
  }
}

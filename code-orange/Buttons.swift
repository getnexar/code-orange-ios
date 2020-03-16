//
//  Buttons.swift
//  code-orange
//
//  Created by shani beracha on 16/03/2020.
//  Copyright © 2020 Renen Elal. All rights reserved.
//

import Foundation
import UIKit

open class NormalButton: UIButton {
  public required init() {
    super.init(frame: .zero)

    initButtonProperties()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    initButtonProperties()
  }
  
  private func initButtonProperties() {
    tintColor = .black
    backgroundColor = .white
    setTitleColor(.black, for: .normal)
    let font = UIFont(name: "OpenSansHebrew-Regular", size: CGFloat(16.0)) ?? UIFont.boldSystemFont(ofSize: 16.0)
    titleLabel?.font = font
    cornerRadius = 8
    borderColor = .white
    borderWidth = 2.0
    setAutoLayoutHeight(52)
    setShadow(.shadow10)
  }
}

open class ApproveButton: UIButton {
  public required init() {
    super.init(frame: .zero)

    initButtonProperties()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    initButtonProperties()
  }
  
  private func initButtonProperties() {
    tintColor       = .black
    backgroundColor = .orange
    setTitleColor(.black, for: .normal)
    let font = UIFont(name: "OpenSansHebrew-Regular", size: CGFloat(14.0)) ?? UIFont.boldSystemFont(ofSize: 14.0)
    titleLabel?.font = font
    cornerRadius = 8
    setAutoLayoutHeight(52)
  }
}

extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
  
  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable var borderColor: UIColor? {
    get {
      return UIColor(cgColor: layer.borderColor!)
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }
  
  func setShadow(_ shadow: Shadow) {
    setShadow(size: shadow.size,
              radius: shadow.radius,
              opacity: shadow.opacity,
              spread: shadow.spread,
              color: shadow.color)
  }
  
  func setShadow(size: CGSize,
                 radius: CGFloat,
                 opacity: Float,
                 spread: CGFloat = 0,
                 color: UIColor = UIColor.black) {
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = size
    layer.shadowRadius = radius
    
    layer.masksToBounds = false
    
    guard spread > 0 else {
      return
    }
    
    let dx: CGFloat = -spread
    let rect = bounds.insetBy(dx: dx, dy: dx)
    let shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
    layer.shadowPath = shadowPath
  }
}

public struct Shadow {
  
  let size: CGSize
  let radius: CGFloat
  let opacity: Float
  let spread: CGFloat
  let color: UIColor
  
  public init(size: CGSize,
              radius: CGFloat,
              opacity: Float,
              spread: CGFloat = 0,
              color: UIColor) {
    self.size = size
    self.radius = radius
    self.opacity = opacity
    self.spread = spread
    self.color = color
  }
}

extension Shadow {
  
  public static var shadow10: Shadow {
    return Shadow(size: CGSize(width: 0, height: 1),
                  radius: 2,
                  opacity: 0.15,
                  spread: 0,
                  color: .black)
  }
}


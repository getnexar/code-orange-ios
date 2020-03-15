 /*
 * 
 * Copyright (c) 2019. Nexar Inc. - All Rights Reserved. Proprietary and confidential.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 *
 */

import UIKit
 
public protocol AutoLayoutAble {
  
  var frame: CGRect { get }
  var leadingAnchor: NSLayoutXAxisAnchor { get }
  var trailingAnchor: NSLayoutXAxisAnchor { get }
  var topAnchor: NSLayoutYAxisAnchor { get }
  var bottomAnchor: NSLayoutYAxisAnchor { get }
  var centerXAnchor: NSLayoutXAxisAnchor { get }
  var centerYAnchor: NSLayoutYAxisAnchor { get }
}
 
extension UIView: AutoLayoutAble {
}
 
extension UILayoutGuide: AutoLayoutAble {
  
  public var frame: CGRect {
    return layoutFrame
  }
}
 
public extension UIView {
  
  enum Anchor {
    case leading(CGFloat)
    case top(CGFloat)
    case bottom(CGFloat)
    case trailing(CGFloat)
  }
  
  enum Operator {
    case ＝＝
    case ＜＝
    case ＞＝
  }
  
  func pin(to layoutAble: AutoLayoutAble, anchors: [Anchor]) {
    anchors.forEach {
      switch $0 {
      case .leading(let constant):
        leadingAnchor.constraint(equalTo: layoutAble.leadingAnchor, constant: constant).isActive = true
        
      case .top(let constant):
        topAnchor.constraint(equalTo: layoutAble.topAnchor, constant: constant).isActive = true
        
      case .trailing(let constant):
        trailingAnchor.constraint(equalTo: layoutAble.trailingAnchor, constant: -constant).isActive = true
        
      case .bottom(let constant):
        bottomAnchor.constraint(equalTo: layoutAble.bottomAnchor, constant: -constant).isActive = true
      }
    }
  }
  
  func fill(_ view: UIView) {
    pin(to: view, anchors: [.leading(0),
                            .top(0),
                            .trailing(0),
                            .bottom(0)])
  }
  
  func fillSuperview() {
    guard let superview = superview else {
      return
    }
    
    fill(superview)
  }

  func pinToSuperview(anchors: [Anchor]) {
    guard let superview = superview else {
      return
    }
    
    pin(to: superview, anchors: anchors)
  }
    
  func fillSafeArea(){
    guard let superview = superview else {
      return
    }
    pinToSafeArea(of: superview, anchors: [.top(0), .bottom(0), .leading(0), .trailing(0)])
  }
  
  func pinToSafeArea(of view: UIView, anchors: [Anchor]) {
    let margins = view.safeAreaLayoutGuide
    pin(to: margins, anchors: anchors)
  }
  
  func pinToSafeArea(of viewController: UIViewController, anchors: [Anchor]) {
    pinToSafeArea(of: viewController.view, anchors: anchors)
  }
  
  func position(above view: UIView,
                constant: CGFloat = 0) {
    bottomAnchor.constraint(equalTo: view.topAnchor, constant: -constant).isActive = true
  }
  
  func position(below view: UIView,
                constant: CGFloat = 0) {
    topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant).isActive = true
  }
  
  func position(after view: UIView,
                constant: CGFloat = 0) {
    leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant).isActive = true
  }
  
  func position(before view: UIView,
                constant: CGFloat = 0) {
    trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -constant).isActive = true
  }
  
  func centerHorizontally(in view: UIView) {
    centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  }
  
  func centerVertically(in view: UIView) {
    centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
  func centerHorizontallyInSuperview() {
    guard let superview = superview else {
      return
    }
    
    centerHorizontally(in: superview)
  }
  
  func centerVerticallyInSuperview() {
    guard let superview = superview else {
      return
    }
    
    centerVertically(in: superview)
  }
  
  func setAutoLayoutHeight(_ height: CGFloat,
                           _ op: Operator = .＝＝) {
    setAutoLayoutDimension(heightAnchor, height, op)
  }
  
  func setAutoLayoutWidth(_ width: CGFloat,
                          _ op: Operator = .＝＝) {
    setAutoLayoutDimension(widthAnchor, width, op)
  }
  
  private func setAutoLayoutDimension(_ dimension: NSLayoutDimension,
                                      _ constant: CGFloat,
                                      _ op: Operator) {
    switch op {
      case .＝＝: dimension.constraint(equalToConstant: constant).isActive = true
      case .＜＝: dimension.constraint(lessThanOrEqualToConstant: constant).isActive = true
      case .＞＝: dimension.constraint(greaterThanOrEqualToConstant: constant).isActive = true
    }
  }
  
  func setSquareRatio() {
    setAspectRatio(widthToHeightRatio: 1)
  }

  func set16to9Ratio() {
    setAspectRatio(widthToHeightRatio: 16 / 9)
  }
  
  func setAspectRatio(widthToHeightRatio: CGFloat) {
    widthAnchor.constraint(equalTo: heightAnchor, multiplier: widthToHeightRatio).isActive = true
  }
}

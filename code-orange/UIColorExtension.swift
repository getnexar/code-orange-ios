/*
*
* Copyright (c) 2015. Nexar Inc. - All Rights Reserved. Proprietary and confidential.
*
* Unauthorized copying of this file, via any medium is strictly prohibited.
*
*/

import Foundation
import UIKit

// TODO: delete deprecated colors when we are done with them (i.e. after full rebranding)
@available(*, deprecated, message: "color is deprecated since the rebranding, please find new colors starting with prefix 'nx' in UIColorExtension")
public extension UIColor {
  
  class func nxGreenColor() -> UIColor {
    return UIColor(red: 56 / 255.0, green: 142 / 255.0, blue: 60 / 255.0, alpha: 1.0)
  }

  class func nxBlueColor() -> UIColor {
    return UIColor(red: 112 / 255.0, green: 159 / 255.0, blue: 219 / 255.0, alpha: 1.0)
  }

  class func nxOrangeColor() -> UIColor {
    return UIColor(red: 238.0 / 255.0, green: 86.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
  }

  class func nxYellowColor() -> UIColor {
    return UIColor(red: 251 / 255.0, green: 176 / 255.0, blue: 64 / 255.0, alpha: 1.0)
  }

  class func nxInsurerGreyColor() -> UIColor {
    return UIColor(red: 203  / 255.0, green: 203 / 255.0, blue: 203 / 255.0, alpha: 1.0)
  }
}

/*
 ******* IMPORTANT ********
 When adding a color from asset catalogue
 make sure to provide a default value equal to the one existing in the catalouge
 */

fileprivate enum NxColors {
  case nxGrey10
  case nxGrey15
  case nxGrey20
  case nxGrey30
  case nxGrey40
  case nxGrey50
  case nxGrey60
  case nxGrey70
  case nxGrey80
  case nxGrey90
  case nxGreen30
  case nxGreen60
  case nxGreen90
  case nxDarkTitle
  case nxPurple10
  case nxPurple50
  case nxPurple60
  case nxRed
  case nxNavy
  case nxWhite
  case nxHighlight
  case nxGreenSuccess
  case nxPurpleFill
  case nxElevatedBackground
  case nxElevated70
  case nxTooltipBackground
  case nxWarning
  case nxInformation
        
  var description: String {
      let name: String
      switch self {
      case .nxGrey10:
        name = "nxGrey10"
      case .nxGrey15:
        name = "nxGrey15"
      case .nxGrey20:
        name = "nxGrey20"
      case .nxGrey30:
        name = "nxGrey30"
      case .nxGrey40:
        name = "nxGrey40"
      case .nxGrey50:
        name = "nxGrey50"
      case .nxGrey60:
        name = "nxGrey60"
      case .nxGrey70:
        name = "nxGrey70"
      case .nxGrey80:
        name = "nxGrey80"
      case .nxGrey90:
        name = "nxGrey90"
      case .nxGreen30:
        name = "nxGreen30"
      case .nxGreen60:
        name = "nxGreen60"
      case .nxGreen90:
        name = "nxGreen90"
      case .nxPurple10:
        name = "nxPurple10"
      case .nxPurple50:
        name = "nxPurple50"
      case .nxPurple60:
        name = "nxPurple60"
      case .nxRed:
        name = "nxRed"
      case .nxNavy:
          name = "nxNavy"
      case .nxWhite:
          name = "nxWhite"
      case .nxGreenSuccess:
          name = "nxGreenSuccess"
      case .nxHighlight:
        name = "nxHighlight"
      case .nxDarkTitle:
        name = "nxDarkTitle"
      case .nxPurpleFill:
        name = "nxPurpleFill"
      case .nxElevatedBackground:
        name = "nxElevatedBackground"
      case .nxElevated70:
        name = "nxElevated70"
      case .nxTooltipBackground:
        name = "nxTooltipBackground"
      case .nxWarning:
        name = "nxWarning"
      case .nxInformation:
        name = "nxInformation"
      }
      return name
  }
}

public extension UIColor {
  typealias FallbackColor = (red: CGFloat, green: CGFloat, blue: CGFloat)
  
  class func named(_ name: String, fallback: FallbackColor) -> UIColor {
    return UIColor(red: fallback.red / 255.0,
                   green: fallback.green / 255.0,
                   blue: fallback.blue / 255.0,
                   alpha: 1.0)
  }
  
  class var nxOrange: UIColor {
    let fallbackColor: FallbackColor = (red: 255.0, green: 192.0, blue: 99.0)
    return UIColor.named(NxColors.nxGrey10.description, fallback: fallbackColor)
  }

  class var nxGrey10: UIColor {
    let fallbackColor: FallbackColor = (red: 250.0, green: 250.0, blue: 250.0)
    return UIColor.named(NxColors.nxGrey10.description, fallback: fallbackColor)
  }
  
  class var nxGrey15: UIColor {
    let fallbackColor: FallbackColor = (red: 244.0, green: 245.0, blue: 245.0)
    return UIColor.named(NxColors.nxGrey15.description,
                         fallback: fallbackColor)
  }
  
  class var nxGrey20: UIColor {
    let fallbackColor: FallbackColor = (red: 239.0, green: 239.0, blue: 241.0)
    return UIColor.named(NxColors.nxGrey20.description,
                         fallback: fallbackColor)
  }
  
  class var nxGrey30: UIColor {
    let fallbackColor: FallbackColor = (red: 228.0, green: 229.0, blue: 231.0)
    return UIColor.named(NxColors.nxGrey30.description,
                         fallback: fallbackColor)
  }
  
  class var nxGrey40: UIColor {
    let fallbackColor: FallbackColor = (red: 217.0, green: 218.0, blue: 221.0)
    return UIColor.named(NxColors.nxGrey40.description,
                         fallback: fallbackColor)
  }
  
  class var nxGrey50: UIColor {
    let fallbackColor: FallbackColor = (red: 179.0, green: 182.0, blue: 187.0)
    return UIColor.named(NxColors.nxGrey50.description,
                         fallback: fallbackColor)
  }
  
  class var nxGrey60: UIColor {
    let fallbackColor: FallbackColor = (red: 141.0, green: 145.0, blue: 154.0)
    return UIColor.named(NxColors.nxGrey60.description,
                         fallback: fallbackColor)
  }
  
  class var nxGrey70: UIColor {
    let fallbackColor: FallbackColor = (red: 113.0, green: 119.0, blue: 130.0)
    return UIColor.named(NxColors.nxGrey70.description,
                         fallback: fallbackColor)
  }
  
  class var nxGrey80: UIColor {
    let fallbackColor: FallbackColor = (red: 62.0, green: 71.0, blue: 89.0)
    return UIColor.named(NxColors.nxGrey80.description,
                         fallback: fallbackColor)
  }
  
  class var nxGrey90: UIColor {
    let fallbackColor: FallbackColor = (red: 12.0, green: 24.0, blue: 49.0)
    return UIColor.named(NxColors.nxGrey90.description,
                         fallback: fallbackColor)
  }
  
  class var nxTooltipBackground: UIColor {
    let fallbackColor: FallbackColor = (red: 12.0, green: 24.0, blue: 49.0)
    return UIColor.named(NxColors.nxTooltipBackground.description,
                         fallback: fallbackColor)
  }
  
  class var nxGreen30: UIColor {
    let fallbackColor: FallbackColor = (red: 211.0, green: 250.0, blue: 247.0)
    return UIColor.named(NxColors.nxGreen30.description,
                         fallback: fallbackColor)
  }
  
  class var nxGreen60: UIColor {
    let fallbackColor: FallbackColor = (red: 167.0, green: 245.0, blue: 239.0)
    return UIColor.named(NxColors.nxGreen60.description,
                         fallback: fallbackColor)
  }
  
  class var nxGreen90: UIColor {
    let fallbackColor: FallbackColor = (red: 35.0, green: 231.0, blue: 216.0)
    return UIColor.named(NxColors.nxGreen90.description,
                         fallback: fallbackColor)
  }

  class var nxDarkTitle: UIColor {
    let fallbackColor: FallbackColor = (red: 35.0, green: 231.0, blue: 216.0)
    return UIColor.named(NxColors.nxDarkTitle.description,
                         fallback: fallbackColor)
  }
  
  class var nxPurple10: UIColor {
    let fallbackColor: FallbackColor = (red: 249.0, green: 247.0, blue: 255.0)
    return UIColor.named(NxColors.nxPurple10.description,
                         fallback: fallbackColor)
  }
  
  class var nxPurple50: UIColor {
    let fallbackColor: FallbackColor = (red: 161, green: 131, blue: 250)
    return .named(NxColors.nxPurple50.description,
                         fallback: fallbackColor)
  }
  
  class var nxPurple60: UIColor {
    let fallbackColor: FallbackColor = (red: 125.0, green: 83.0, blue: 248.0)
    return UIColor.named(NxColors.nxPurple60.description,
                         fallback: fallbackColor)
  }
  
  class var nxPurpleFill: UIColor {
     let fallbackColor: FallbackColor = (red: 125.0, green: 83.0, blue: 248.0)
     return UIColor.named(NxColors.nxPurpleFill.description,
                          fallback: fallbackColor)
   }
  
  class var nxRed: UIColor {
    let fallbackColor: FallbackColor = (red: 224.0, green: 0.0, blue: 45.0)
    return UIColor.named(NxColors.nxRed.description,
                         fallback: fallbackColor)
  }
  
  class var nxNavy: UIColor {
    let fallbackColor: FallbackColor = (red: 26.0, green: 20.0, blue: 133.0)
    return UIColor.named(NxColors.nxNavy.description,
                         fallback: fallbackColor)
  }
  
  class var nxWhite: UIColor {
    let fallbackColor: FallbackColor = (red: 255.0, green: 255.0, blue: 255.0)
    return UIColor.named(NxColors.nxWhite.description,
                         fallback: fallbackColor)
  }
  
  class var nxHighlight: UIColor {
    let fallbackColor: FallbackColor = (red: 255.0, green: 255.0, blue: 255.0)
    return UIColor.named(NxColors.nxHighlight.description,
                         fallback: fallbackColor)
  }
  
  class var nxElevatedBackground: UIColor {
    let fallbackColor: FallbackColor = (red: 255.0, green: 255.0, blue: 255.0)
    return UIColor.named(NxColors.nxElevatedBackground.description,
                         fallback: fallbackColor)
  }
  
  class var nxElevated70: UIColor {
    let fallbackColor: FallbackColor = (red: 255.0, green: 255.0, blue: 255.0)
    return UIColor.named(NxColors.nxElevated70.description,
                         fallback: fallbackColor)
  }
  
  class var nxGreenSuccess: UIColor {
    let fallbackColor: FallbackColor = (red: 0.0, green: 133.0, blue: 74.0)
    return UIColor.named(NxColors.nxGreenSuccess.description,
                         fallback: fallbackColor)
  }
  
  class var nxWarning: UIColor {
    let fallbackColor: FallbackColor = (red: 255, green: 165, blue: 20)
    return .named(NxColors.nxWarning.description,
                         fallback: fallbackColor)
  }
  
  class var nxInformation: UIColor {
    let fallbackColor: FallbackColor = (red: 71, green: 102, blue: 255)
    return .named(NxColors.nxInformation.description,
                         fallback: fallbackColor)
  }

  func withAlpha(_ newAlpha: Float) -> UIColor {
    var red = CGFloat()
    var green = CGFloat()
    var blue = CGFloat()
    var alpha = CGFloat()
    getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(newAlpha))
  }
}

//
//  ColorScheme.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 8/4/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

/*
*  💡 Usage Examples
*  let shadowColor = Color.shadow.value
*  let shadowColorWithAlpha = Color.shadow.withAlpha(0.5)
*  let customColorWithAlpha = Color.custom(hexString: "#123edd", alpha: 0.25).value
*/

enum Color {
    
    case theme
    case border
    case shadow
    
    case brightYarrow
    case sourLemon
    case soothingBreeze
    case cityLights
    case electronBlue
    
    case darkBackground
    case lightBackground
    case intermidiateBackground
    
    case darkText
    case lightText
    case intermediateText
    
    case affirmation
    case negation
    
    case custom(hexString: String, alpha: Double)
    
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}

extension Color {
    
    var value: UIColor {
        var instanceColor = UIColor.clear
        
        switch self {
        case .border:
            break
        case .theme:
            break
        case .shadow:
            break
        case .brightYarrow:
            instanceColor = UIColor(hexString: "#fdcb6e")
        case .sourLemon:
            instanceColor = UIColor(hexString: "#ffeaa7")
        case .soothingBreeze:
            instanceColor = UIColor(hexString: "#b2bec3")
        case .cityLights:
            instanceColor = UIColor(hexString: "#dfe6e9")
        case .electronBlue:
            instanceColor = UIColor(hexString: "#0984e3")
        case .darkBackground:
            instanceColor = UIColor(hexString: "#74b9ff")
        case .lightBackground:
            instanceColor = UIColor(hexString: "#ededed")
        case .intermidiateBackground:
            break
        case .darkText:
            break
        case .intermediateText:
            break
        case .lightText:
            break
        case .affirmation:
            break
        case .negation:
            break
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
        }
        return instanceColor
    }
}

extension UIColor {
    /**
     Creates an UIColor from HEX String in "#363636" format
     
     - parameter hexString: HEX String in "#363636" format
     
     - returns: UIColor from HexString
     */
    convenience init(hexString: String) {
        
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner          = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "#%02x%02x%02x%02x", Int(red * 255), Int(green * 255), Int(blue * 255), Int(alpha * 255))
    }
}

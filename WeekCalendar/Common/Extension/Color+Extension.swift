
//
//  Color+Extensions.swift
//  HayEquipo
//
//  Created by David Gomez on 09/04/2023.
//

import UIKit
import SwiftUI

extension Color {
    init?(hex: String, alpha: Double? = nil) {
        var formattedHex = hex
        if formattedHex.hasPrefix("#") {
            formattedHex.remove(at: formattedHex.startIndex)
        }
        
        guard let hexValue = UInt(formattedHex, radix: 16) else {
            return nil
        }
        
        let red = Double((hexValue & 0xFF0000) >> 16) / 255.0
        let green = Double((hexValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(hexValue & 0x0000FF) / 255.0
        
        if let alpha = alpha {
            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
        } else {
            self.init(.sRGB, red: red, green: green, blue: blue)
        }
    }
}

extension UIColor {
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var formattedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if formattedHex.hasPrefix("#") {
            formattedHex.remove(at: formattedHex.startIndex)
        }
        
        if formattedHex.count != 6 {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: formattedHex).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension Color {
    enum Gradient {
        static var firstColor: Color { return Color("Gradient-First", bundle: nil) }
        static var secondColor: Color { return Color("Gradient-Second", bundle: nil) }
        static var thirdColor: Color { return Color("Gradient-Third", bundle: nil) }
    }
    
    enum Purple {
        static var purple200: Color { return Color("Purple-200", bundle: nil) }
        static var purpleX: Color { return Color("Purple-x", bundle: nil) }
    }
    
    enum Blue {
        static var tone100: Color { return Color("Blue-Purple-100", bundle: nil) }
        static var tone150: Color { return Color("Blue-Purple-150", bundle: nil) }
        static var tone200: Color { return Color("Blue-Purple-200", bundle: nil) }
        static var tone300: Color { return Color("Blue-Purple-300", bundle: nil) }
        static var toneXXX: Color { return Color("Blue-Purple-xxx", bundle: nil) }
        static var toneXX1: Color { return Color("Blue-Purple-xx1", bundle: nil) }
        
        static var light: Color { return Color("LightBlue", bundle: nil) }
        static var medium: Color { return Color("MediumBlue", bundle: nil) }
        static var midnight: Color { return Color("MidnightBlue", bundle: nil) }
        static var truly: Color { return Color("TrueBlue", bundle: nil) }
        static var wash: Color { return Color("WashBlue", bundle: nil) }
    }
    
    enum Green {
        static var light: Color { return Color("LightGreen", bundle: nil) }
        static var medium: Color { return Color("MediumGreen", bundle: nil) }
        static var midnight: Color { return Color("MidnightGreen", bundle: nil) }
        static var truly: Color { return Color("TrueGreen", bundle: nil) }
        static var wash: Color { return Color("WashGreen", bundle: nil) }
    }
    
    enum Pink {
        static var pinkXXX: Color { return Color("Pink-xxx", bundle: nil) }
        static var pinkXX1: Color { return Color("Pink-xx1", bundle: nil) }
    }
    
    enum Dark {
        static var tone100: Color { return Color("Dark-100", bundle: nil) }
        static var tone90: Color { return Color("Dark-90", bundle: nil) }
        static var tone80: Color { return Color("Dark-80", bundle: nil) }
        static var tone70: Color { return Color("Dark-70", bundle: nil) }
    }
    
    enum Neutral {
        static var tone0: Color { return Color("Neutral-0", bundle: nil) }
        static var tone70: Color { return Color("Neutral-70", bundle: nil) }
        static var tone80: Color { return Color("Neutral-80", bundle: nil) }
        static var tone90: Color { return Color("Neutral-90", bundle: nil) }
        static var tone100: Color { return Color("Neutral-100", bundle: nil) }
        static var black: Color { return Color("Black", bundle: nil) }
        static var border: Color { return Color("Border", bundle: nil) }
        static var placeholder: Color { return Color("Placeholder", bundle: nil) }
        static var grayText: Color { return Color("GrayText", bundle: nil) }
        static var wash: Color { return Color("Wash", bundle: nil) }
    }
    
    enum Status {
        static var error: Color { return Color("Error", bundle: nil) }
        static var success: Color { return Color("Success", bundle: nil) }
        static var warning: Color { return Color("Warning", bundle: nil) }
    }
    
    enum Primary {
        static var primary100: Color { return Color("Primary-100", bundle: nil) }
        static var primary300: Color { return Color("Primary-300", bundle: nil) }
    }
    
    enum Orange {
        static var orange100: Color { return Color("Orange-100", bundle: nil) }
    }
    
    enum Red {
        static var tone90: Color { return Color("Red-90", bundle: nil) }
        static var tone100: Color { return Color("Red-100", bundle: nil) }
        static var light: Color { return Color("LightRed", bundle: nil) }
        static var medium: Color { return Color("MediumRed", bundle: nil) }
        static var midnight: Color { return Color("MidnightRed", bundle: nil) }
        static var truly: Color { return Color("TrueRed", bundle: nil) }
        static var wash: Color { return Color("WashRed", bundle: nil) }
    }
    
    enum Violet {
        static var light: Color { return Color("LightViolet", bundle: nil) }
        static var medium: Color { return Color("MediumViolet", bundle: nil) }
        static var midnight: Color { return Color("MidnightViolet", bundle: nil) }
        static var trueViolet: Color { return Color("TrueViolet", bundle: nil) }
        static var wash: Color { return Color("WashViolet", bundle: nil) }
    }
    
    enum Seafoam {
        static var light: Color { return Color("LightSeafoam", bundle: nil) }
        static var medium: Color { return Color("MediumSeafoam", bundle: nil) }
        static var midnight: Color { return Color("MidnightSeafoam", bundle: nil) }
        static var trueSeafoam: Color { return Color("TrueSeafoam", bundle: nil) }
        static var wash: Color { return Color("WashSeafoam", bundle: nil) }
    }
    
    enum Yellow {
        static var tone80: Color { return Color("Yellow-80", bundle: nil) }
        static var light100: Color { return Color("Yellow-100", bundle: nil) }
        static var light: Color { return Color("LightYellow", bundle: nil) }
        static var medium: Color { return Color("MediumYellow", bundle: nil) }
        static var midnight: Color { return Color("MidnightYellow", bundle: nil) }
        static var trueYellow: Color { return Color("TrueYellow", bundle: nil) }
        static var wash: Color { return Color("WashYellow", bundle: nil) }
    }
    
    enum Apricot {
        static var light: Color { return Color("LightApricot", bundle: nil) }
        static var medium: Color { return Color("MediumApricot", bundle: nil) }
        static var midnight: Color { return Color("MidnightApricot", bundle: nil) }
        static var trueApricot: Color { return Color("TrueApricot", bundle: nil) }
        static var wash: Color { return Color("WashApricot", bundle: nil) }
    }
    
    enum Chartreuse {
        static var light: Color { return Color("LightChartreuse", bundle: nil) }
        static var medium: Color { return Color("MediumChartreuse", bundle: nil) }
        static var midnight: Color { return Color("MidnightChartreuse", bundle: nil) }
        static var trueChartreuse: Color { return Color("TrueChartreuse", bundle: nil) }
        static var wash: Color { return Color("WashChartreuse", bundle: nil) }
    }
}


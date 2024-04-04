//
//  UIColor+Extension.swift
//  Tracker
//
//  Created by Андрей Тапалов on 04.04.2024.
//

import UIKit

extension UIColor {
    func hex(_ rgbValue: Int64, alpha: Float) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

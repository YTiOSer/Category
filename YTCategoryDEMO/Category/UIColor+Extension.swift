//
//  UIColor+Extension.swift
//  YTCategoryDEMO
//
//  Created by YTiOSer on 18/5/15.
//  Copyright © 2018 YTiOSer. All rights reserved.
//

import UIKit


extension UIColor {

    /// 颜色
    ///
    /// - Parameters:
    ///   - r: red
    ///   - g: green
    ///   - b: blue
    /// - Returns: UIColor
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    /// 颜色
    ///
    /// - Parameters:
    ///   - hexColor: 十六进制码
   /// - Returns: UIColor
    class func HexColor(_ hexColor: Int32 ) -> UIColor {
        let r = CGFloat(((hexColor & 0x00FF0000) >> 16)) / 255.0
        let g = CGFloat(((hexColor & 0x0000FF00) >> 8)) / 255.0
        let b = CGFloat(hexColor & 0x000000FF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
}

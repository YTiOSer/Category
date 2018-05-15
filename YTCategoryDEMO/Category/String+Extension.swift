//
//  UIColor+Extension.swift
//  YTCategoryDEMO
//
//  Created by YTiOSer on 18/5/15.
//  Copyright © 2018 YTiOSer. All rights reserved.
//

import UIKit

extension String {

    /// MD5
    ///
    /// - Returns: 转为MD5
    public func stringFromMD5() -> NSString {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        if let data = self.data(using: String.Encoding.utf8.rawValue) {
            CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)
        }
        
        let digestHex = digest.map { String(format: "%02x", $0) }.joined(separator: "")
        
        return digestHex as NSString
    }
    
    /// 获取高度计算
    ///
    /// - Parameters:
    ///   - size: 矩形已知范围
    ///   - attributes: 文字属性
    /// - Returns: 高度
    public func height(_ size: CGSize, _ attributes: [NSAttributedStringKey: Any]?) -> CGFloat {

        let string = self as NSString

        let stringSize = string.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        return stringSize.height

    }
    /// 获取宽度计算
    ///
    /// - Parameters:
    ///   - size: 矩形已知范围
    ///   - attributes: 文字属性
    /// - Returns: 宽度
    public func width(_ size: CGSize, _ attributes: [NSAttributedStringKey: Any]?) -> CGFloat {

        let string = self as NSString

        let stringSize = string.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        return stringSize.width

    }

}

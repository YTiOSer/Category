//
//  UIColor+Extension.swift
//  YTCategoryDEMO
//
//  Created by YTiOSer on 18/5/15.
//  Copyright © 2018 YTiOSer. All rights reserved.
//

import UIKit

extension UIImage {

    /// 获得原图
    ///
    /// - Returns: cicleImage
    public func cicleImage() -> UIImage {

        // 开启图形上下文 false代表透明
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        // 获取上下文
        let ctx = UIGraphicsGetCurrentContext()
        // 添加一个圆
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        ctx?.addEllipse(in: rect)
        // 裁剪
        ctx?.clip()
        // 将图片画上去
        draw(in: rect)
        // 获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    /// 裁剪给定区域
    /// crop: 裁剪区域
    /// - Returns: cropImage
    public func cropWithCropRect( _ crop: CGRect) -> UIImage?
    {
        let cropRect = CGRect(x: crop.origin.x * self.scale, y: crop.origin.y * self.scale, width: crop.size.width * self.scale, height: crop.size.height *  self.scale)
        
        if cropRect.size.width <= 0 || cropRect.size.height <= 0 {
            return nil
        }
        var image:UIImage?
        autoreleasepool{
            let imageRef: CGImage?  = self.cgImage!.cropping(to: cropRect)
            if let imageRef = imageRef {
                image = UIImage(cgImage: imageRef)
            }
        }
        return image
    }
    
    /// 设置图片透明度
    /// alpha: 透明度
    /// - Returns: newImage
    func imageByApplayingAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -area.height)
        context?.setBlendMode(.multiply)
        context?.setAlpha(alpha)
        context?.draw(self.cgImage!, in: area)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
    
    /// 按比例减少尺寸
    ///
    /// - Parameter sz: 原始图像尺寸.
    /// - Parameter limit:目标尺寸.
    /// - Returns: 函数按比例返回缩小后的尺寸
    func reduceSize(_ sz: CGSize, _ limit: CGFloat) -> CGSize {
        let maxPixel = max(sz.width, sz.height)
        guard maxPixel > limit else {
            return sz
        }
        var resSize: CGSize!
        let ratio = sz.height / sz.width;
        
        if (sz.width > sz.height) {
            resSize = CGSize(width:limit, height:limit*ratio);
        } else {
            resSize = CGSize(width:limit/ratio, height:limit);
        }
        
        return resSize;
    }

    // MARK: - 图片压缩
    /// 图片压缩
    ///
    ///     eg:
    ///     oldImg?.compressImage(1024*1024*1, 1000.0, {(data) in
    ///     let img = UIImage(data: data)
    ///     tv.text.append("图片最大值不超过最大边1M 以及 最大边不超过1000PX的大小 \(self.M(Double((data.count)))) M\n")
    ///     tv.text.append("图片最大值不超过最大边1M 以及 最大边不超过1000PX的宽度 \(img!.size.width)\n")
    ///     tv.text.append("图片最大值不超过最大边1M 以及 最大边不超过1000PX的高度 \(img!.size.height)\n\n")
    ///     tv.text.append("-------------------------------\n")
    ///     })
    ///
    /// - Parameter limitSize:限制图像的大小.
    /// - Parameter maxSideLength: 缩小后的尺寸.
    /// - Parameter completion: 闭包回调.
    /// - Returns: 函数按比例返回压缩后的图像
    func compressImage( _ limitSize: Int, _ maxSideLength: CGFloat, _ completion: @escaping (_ dataImg: Data)->Void ) {
        guard limitSize>0 || maxSideLength>0 else {
            return
        }
        //weak var weakSelf = self
        let compressQueue = DispatchQueue(label: "image_compress_queue")
        compressQueue.async {
            var quality = 0.7
            let img = self.scaleImage(maxSideLength)
            var imageData = UIImageJPEGRepresentation(img, CGFloat(quality) )
            guard imageData != nil else { return }
            if (imageData?.count)! <= limitSize {
                DispatchQueue.main.async(execute: {//在主线程里刷新界面
                    completion(imageData!)
                })
                return
            }
            
            repeat {
                autoreleasepool {
                    imageData = UIImageJPEGRepresentation(img, CGFloat(quality))
                    quality = quality-0.05
                }
            } while ((imageData?.count)! > limitSize);
            DispatchQueue.main.async(execute: {//在主线程里刷新界面
                completion(imageData!)
            })
        }
    }

}

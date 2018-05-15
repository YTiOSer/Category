//
//  UIColor+Extension.swift
//  YTCategoryDEMO
//
//  Created by YTiOSer on 18/5/15.
//  Copyright © 2018 YTiOSer. All rights reserved.
//

import UIKit

extension NSObject {
    
    class var nameOfClass: String {
        return (NSStringFromClass(self).components(separatedBy: ".").last) ?? ""
    }
    
    /// 设置关联对象
    func setAssociatedObject(_ obj:AnyObject,key:UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /// 获取关联对象
    func associatedObjectForKey(_ key:UnsafeRawPointer) -> AnyObject? {
        return objc_getAssociatedObject(self, key) as AnyObject?
    }
    
    /// 去掉所有关联对象
    func removeAssociatedObjects() {
        objc_removeAssociatedObjects(self)
    }
    
    func postNotification(_ name:String,object:AnyObject? = nil,userInfo:[String:AnyObject]? = nil) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: object,userInfo:userInfo )
    }
    
    func addNotificationObserver(_ selector:Selector,name:String?,object:AnyObject?) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name.map { NSNotification.Name(rawValue: $0) }, object: object)
    }
    
    func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}



![Category](https://upload-images.jianshu.io/upload_images/8283020-ebf7d06a341a4ef0.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 最近开发新项目, 需要搭一个框架, 在写常用**Category**时候, 发现之前写的比较乱,且不够完善,  这次特意总结了下,并且丰富了category库, 框架搭好了,有时间了专门写一篇文章来总结和分享下.,如果对您有所帮助的话,麻烦给个**star**喔!

- ### UIView
可获取和设置View的x y 宽 高上 下 左 右 及中心点
1. x
```
var yt_x: CGFloat {
get {
return frame.origin.x
}
set{
var tempFrame: CGRect = frame
tempFrame.origin.x = newValue
frame = tempFrame
}
}
```
2. y
```
var yt_y: CGFloat {
set {
var tempFrame: CGRect = frame
tempFrame.origin.y = newValue
frame = tempFrame
}
get {
return frame.origin.y

}

}
```
3. width
```
var yt_width : CGFloat {
get {
return frame.size.width
}

set(newVal) {
var tmpFrame : CGRect = frame
tmpFrame.size.width   = newVal
frame                 = tmpFrame
}
}
```
4. height
```
var yt_height : CGFloat {
get {
return frame.size.height
}

set(newVal) {
var tmpFrame : CGRect = frame
tmpFrame.size.height  = newVal
frame                 = tmpFrame
}
}
```
5. left 
```
var yt_left : CGFloat {
get {
return yt_x
}

set(newVal) {
yt_x = newVal
}
}
```
6. right
```
var yt_right : CGFloat {
get {
return yt_x + yt_width
}

set(newVal) {
yt_x = newVal - yt_width
}
}
```
7. top
```
var yt_top : CGFloat {
get {
return yt_y
}

set(newVal) {
yt_y = newVal 
}
}
```
8. bottom
```
var yt_bottom : CGFloat {
get {
return yt_y + yt_height
}

set(newVal) {
yt_y = newVal - yt_height
}
}
```
9. center
```
var yt_center: CGPoint {
get {
return CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
}
set {
center = CGPoint(x: newValue.x, y: newValue.y)
}
}
```
10. center.x
```
var yt_centerX : CGFloat {
get {
return center.x
}

set(newVal) {
center = CGPoint(x: newVal, y: center.y)
}
}
```
11. center.y
```
var yt_centerY : CGFloat {
get {
return center.y
}

set(newVal) {
center = CGPoint(x: center.x, y: newVal)
}
}
```

- ###  时间
总结了时间差 判断同一年 今天 昨天 前两天等
```
extension Date {

/// 时间差
///
/// - Parameter fromDate: 起始时间
/// - Returns: 对象
public func daltaFrom(_ fromDate: Date) -> DateComponents {
let calendar = Calendar.current
let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
return calendar.dateComponents(components, from: fromDate, to: self)
}

/// 是否是同一年
///
/// - Returns: ture or false
func isThisYear() -> Bool {
let calendar = Calendar.current
let currendarYear = calendar.component(.year, from: Date())
let selfYear =  calendar.component(.year, from: self)
return currendarYear == selfYear
}

/// 是否是今天的时间
///
/// - Returns: Bool
public func isToday() -> Bool{

let currentTime = Date().timeIntervalSince1970

let selfTime = self.timeIntervalSince1970

return (currentTime - selfTime) <= (24 * 60 * 60)
}

/// 是否是昨天的时间
///
/// - Returns: Bool
public func isYesToday() -> Bool {

let currentTime = Date().timeIntervalSince1970

let selfTime = self.timeIntervalSince1970

return (currentTime - selfTime) > (24 * 60 * 60)
}

/// 是否是近两天的时间
///
/// - Returns: Bool
public func isYesToday() -> Bool {

let currentTime = Date().timeIntervalSince1970

let selfTime = self.timeIntervalSince1970

return (currentTime - selfTime) <= (24 * 2 * 60 * 60)
}

}

```

- ### 图片 UIImage
UIImage包含 获取原图, 裁剪区域, 设置透明度,按比例减少尺寸,图片压缩等.
```
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
```

- ###  字符串String
包含字符串MD5加密,获取字符串的宽度和高度.
```
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

```

- ### UIColor
通过RGB和Hex十六进制码快速创建UIColor.
```
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
```

- ### NSObject
可通过字符串获取类,设置获取和去掉关联对象,发送接收和移除通知等.
```
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
```

>项目中用到的字符串,图片,View,Color等基本上都包含了,我在搭建项目时候使用了这些**Category**,当然每个项目不同,所需要的框架也不同,仅供大家参考,有可以使用的大家可以直接使用.

>当然时间仓促, 总结的难免出现什么问题或者缺少,大家发现有问题或者有补充的欢迎留言. 最后如果对大家有所帮助不妨关注喜欢下哈!





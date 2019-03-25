
<p align="center">
<a href="https://github.com/GTMYang/GTMBarcodeScanner"><img src="https://github.com/GTMYang/GTMBarcodeScanner/blob/master/Demo/logo.png"></a>
</p>

<p align="center">
<a href="https://github.com/GTMYang/GTMBarcodeScanner"><img src="https://img.shields.io/badge/platform-ios-lightgrey.svg"></a>
<!--<a href="https://github.com/GTMYang/GTMBarcodeScanner"><img src="https://img.shields.io/github/license/johnlui/Pitaya.svg?style=flat"></a>-->
<a href="https://github.com/GTMYang/GTMBarcodeScanner"><img src="https://img.shields.io/badge/language-Swift%204-orange.svg"></a>
<a href="https://travis-ci.org/GTMYang/GTMBarcodeScanner"><img src="https://img.shields.io/travis/johnlui/Pitaya.svg"></a>
</p>

<br>

GTMBarcodeScanner
===================
Swift 实现的条码扫描组件库

# 说明

- 支持设置不同风格的扫码动效
- 支持光线强度检测
- 支持条码太小时候自动拉近镜头效果
- 支持自定义扫码音效
- 支持识别图片中的条码
- 支持生成带图片的条码


# 例子
直接下载代码，里面Example里面有详细的使用实例代码

![alt tag](https://github.com/GTMYang/GTMBarcodeScanner/blob/master/Demo/1.png)
![alt tag](https://github.com/GTMYang/GTMBarcodeScanner/blob/master/Demo/2.png)
![alt tag](https://github.com/GTMYang/GTMBarcodeScanner/blob/master/Demo/3.png)
![alt tag](https://github.com/GTMYang/GTMBarcodeScanner/blob/master/Demo/4.png)



# 安装

## Cocoapods方式

Cocoapods 安装.

```bash
$ gem install cocoapods
```

添加  `GTMBarcodeScanner` 到你的 `Podfile` 文件.

```ruby
use_frameworks!

pod 'GTMBarcodeScanner'
```

接着，执行下面的命令.

```bash
$ pod install
```


## 常规方式

拷贝 `GTMBarcodeScanner`  目录到你的项目. 


# 版本

## Vesrion 1.0.1

该版本需要 Xcode 9.0 和 Swift 4.2.

# 使用帮助

首先, 导入 `GTMBarcodeScanner`.

```swift
import GTMBarcodeScanner
```

## 创建Scanner
```swift
let scanner = BarcodeScanner.create(view: self.view)

// 风格设置
scanner.makeStyle { (make) in
    let color = UIColor.init(red: 255/255, green: 157/255, blue: 0/255, alpha: 1)
    make.positionUpVal(44)
    make.anglePosition(ScanViewStyle.AnglePosition.inner)
    make.angleLineWeight(5)
    make.angleLineLength(18)
    make.isShowRetangleBorder(true)
    make.width(280)
    make.height(180)
    make.retangleLineWeight(1/UIScreen.main.scale)
    make.animateType(ScanViewStyle.Animation.lineMove)
    make.colorOfAngleLine(color)
    make.colorOfRetangleLine(color)
    let c = UIColor(red: 255/255, green: 157/255, blue: 0/255, alpha: 0.5)
    make.colorOutside(c)
    make.soundSource(forName: "VoiceSearchOn", andType: "wav")
}

// 配置
scanner.config { (make) in
    make.autoCloser(true)       // 自动拉近镜头
    make.caputureImage(true)    // 记录扫码的源图片
    make.printLog(true)         // 调试信息打印控制
}

// 设置代理
scanner.delegate = self

// 开始扫码
scanner.start()
```

## 代理对象
```swift
public protocol GTMBarcodeCoreDelegate: class {
    func barcodeRecognized(result: BarcodeResult)
    func lightnessChange(needFlashButton: Bool)
    func barcodeForPhoto(result: BarcodeResult?)
}
```


## 风格设置

```swift
public struct ScanViewStyle {

    /// 是否需要绘制扫码矩形框，默认YES
    public var isShowRetangle:Bool = true
    public var size = CGSize(width: 255, height: 255)
    public var positionUpVal: CGFloat = 44
    ///矩形框线条颜色，默认白色
    public var colorRetangleLine = UIColor.white
    ///4个角的颜色
    public var colorAngleLine = UIColor(red: 0.0, green: 167.0/255.0, blue: 231.0/255.0, alpha: 1.0)
    ///非识别区域颜色,默认 RGBA (0,0,0,0.5)，范围（0--1）
    public var colorOutside = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)

    ///扫码区域的4个角类型
    public var anglePosition = AnglePosition.outer


    ///扫码区域4个角的宽度和高度
    public var angleW:CGFloat = 24.0
    public var angleH:CGFloat = 24.0
    ///扫码区域4个角的线条宽度,默认6，建议8到4之间
    public var angleLineWeight: CGFloat = 6
    public var retangleLineWeight: CGFloat = 1

    ///扫码动画效果: 线条或网格
    public var animateType = Animation.lineMove

    /// 动画效果的图像，如线条或网格的图像
    public var animateImage:UIImage?
    /// 动画 duration 值, 默认值 2.6
    public var animateDuration: TimeInterval = 2.6

    /// 扫描提示音资源文件
    public var soundSource: (name: String, type: String)?


    public init() { }
    
    public enum Animation {
        case lineMove
        case gridGrow
        case none
    }
    
    public enum AnglePosition {
        case inner
        case outer
        case on
    }
}

```

## 参考
本库参考了[swifScan](https://github.com/MxABC/swiftScan)


## 参与开源

欢迎提交 issue 和 PR，大门永远向所有人敞开。

## 开源协议
本项目遵循个人协议开源，具体请查看根目录下的 [LICENSE](https://github.com/GTMYang/GTMBarcodeScanner/blob/master/LICENSE) 文件。



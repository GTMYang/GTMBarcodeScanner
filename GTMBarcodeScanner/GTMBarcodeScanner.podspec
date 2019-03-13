

Pod::Spec.new do |s|

  s.name         = "GTMBarcodeScanner"
  s.version      = "0.2"
  s.summary      = "Swift 实现的条码扫描组件库"
  s.swift_version= "4.2"

  s.homepage     = "https://github.com/GTMYang/GTMBarcodeScanner"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "GTMYang" => "17757128523@163.com" }


  s.source       = { :git => "https://github.com/GTMYang/GTMBarcodeScanner.git", :tag => s.version }

  s.source_files = "GTMBarcodeScanner/Classes/*.swift"
  s.resources    = 'GTMBarcodeScanner/Resource/*.{png, wav}'

  s.ios.deployment_target = "8.0"

  s.ios.framework  = 'UIKit'
#s.frameworks = "AVFoundation, ImageIO"
#s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }

end

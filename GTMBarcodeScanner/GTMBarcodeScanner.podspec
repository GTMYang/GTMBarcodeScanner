
Pod::Spec.new do |s|

  s.name         = "GTMBarcodeScanner"
  s.version      = "0.13"
  s.summary      = "Swift 实现的条码扫描组件库"
  s.swift_version= "4.2"

  s.homepage     = "https://github.com/GTMYang/GTMBarcodeScanner"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "GTMYang" => "17757128523@163.com" }


  s.source       = { :git => "https://github.com/GTMYang/GTMBarcodeScanner.git", :tag => s.version }

  s.source_files = "GTMBarcodeScanner/*.{h,swift}"
  s.resources    = "GTMBarcodeScanner/Resource/**/*"

  s.ios.deployment_target = "8.0"
  s.framework  = 'UIKit'

end

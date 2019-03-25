# MHSegmentedControl


[![CI Status](https://img.shields.io/travis/menhui222/MHSegmentedControl.svg?style=flat)](https://travis-ci.org/menhui222/MHSegmentedControl)
[![Version](https://img.shields.io/cocoapods/v/MHSegmentedControl.svg?style=flat)](https://cocoapods.org/pods/MHSegmentedControl)
[![License](https://img.shields.io/cocoapods/l/MHSegmentedControl.svg?style=flat)](https://cocoapods.org/pods/MHSegmentedControl)
[![Platform](https://img.shields.io/cocoapods/p/MHSegmentedControl.svg?style=flat)](https://cocoapods.org/pods/MHSegmentedControl)
[![weibo](https://img.shields.io/badge/weibo-@孟辉-yellow.svg?style=flat)](https://weibo.com/u/2415625901/home?topnav=1&wvr=6)
## Example

![Example](SegmentedControlExample.gif)

####Usage
Text

```

let s1 = SegmentedControl(titleData: ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"],
frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))




self.view.addSubview(s1)
```
```
var config = SegmentedConfig()
config.chief_w = 50
config.trail_w = 50
config.space_w = 50
config.itemSelectedColor = UIColor.yellow
config.itemDefultColor = UIColor.gray
config.titleFont = UIFont.systemFont(ofSize: 30)

let s2 = SegmentedControl(config:config,titleData: ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"],
frame: CGRect(x: 0, y: 70, width: self.view.frame.width, height: 40))



//如果要修改
s2.configSegmentItem {  () in
var config = SegmentedConfig()
config.titleFont = UIFont.systemFont(ofSize: 20)
config.itemSelectedColor = UIColor.yellow
return config
}
s2.lineColor = UIColor.yellow

self.view.addSubview(s2)

s2.segmentedItemSelected = {(model) in
//            model.index
//            model.size
//            model.text
}

```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MHSegmentedControl is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MHSegmentedControl'
```

## Author

menhui222, menhui222@163.com

## License

MHSegmentedControl is available under the MIT license. See the LICENSE file for more info.


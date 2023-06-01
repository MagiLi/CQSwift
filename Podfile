# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

use_frameworks!

# 使用关键字abstract_target，使用多个target共享同一个pod
widgetTargets = ['CQStaticWidgetExtension','CQWidgetsExtension']

def common
  pod 'Alamofire'
end

target 'CQSwift' do
  common
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'SwiftTheme'
  pod 'Swifter'
end

target 'CQStaticWidgetExtension' do
  common
end

target 'CQWidgetsExtension' do
  common
end
## RxTests 和 RxBlocking 将在单元/集成测试中起到重要作用
#target 'YOUR_TESTING_TARGET' do
#    pod 'RxBlocking', '~> 4.0'
#    pod 'RxTest',     '~> 4.0'
#end”

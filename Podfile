
# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

source 'https://github.com/CocoaPods/Specs.git'

target 'Arcadegame' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'AFNetworking'
  pod 'JSONModel'
  pod 'SDWebImage'
  pod 'MBProgressHUD'
  pod 'MJExtension'
  pod 'Masonry'
  pod 'IQKeyboardManager'
  pod 'pop'
  pod 'MCUIColorUtils'
  pod 'Toast'
  pod 'UICountingLabel'
  pod 'CocoaAsyncSocket'
  pod 'ReactiveObjC', '~>3.1.1'
  pod 'WMPageController', '~>2.4.0'
  pod 'WsRTC'
  pod 'SDCycleScrollView'
  pod 'JXCategoryView'
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
  
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    config.build_settings['VALID_ARCHS'] = 'arm64 arm64e armv7 armv7s x86_64 i386'
    config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
  end
end
    


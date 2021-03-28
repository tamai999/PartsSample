# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'PartsSample' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'R.swift', '~> 5.4.0'
  pod 'SnapKit', '~> 5.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end
end


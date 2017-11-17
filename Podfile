# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'keychainSwift' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for keychainSwift
  pod 'Fabric'
  pod 'Crashlytics'  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |configuration|
      configuration.build_settings['SWIFT_VERSION'] = "3"
      configuration.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = ['$(inherited)']
    end
  end
end

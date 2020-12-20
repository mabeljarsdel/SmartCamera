# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Translate Camera' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for scannerApp
	
	pod 'GoogleMLKit/TextRecognition'
	pod 'SnapKit', '~> 5.0.0'
  	pod 'GoogleMLKit/LanguageID'
  	pod 'GoogleMLKit/Translate'
	pod 'Firebase'
	pod 'Firebase/MLVision'
	pod 'GoogleMLKit/LanguageID'


  
end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
 end
 end
end
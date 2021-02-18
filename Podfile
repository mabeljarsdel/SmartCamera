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
	pod 'GoogleMLKit/LanguageID'
	pod 'Firebase/MLVision'
  pod 'Firebase/MLNLTranslate'

  pod 'GoogleMLKit/ObjectDetection'
  pod 'GoogleMLKit/ObjectDetectionCustom'

  pod 'GoogleMLKit/LinkFirebase'
  
  pod 'GoogleMLKit/ImageLabeling'
  pod 'GoogleMLKit/ImageLabelingCustom'
  
  pod 'UIImageColors'

  pod 'UIDrawer', :git => 'https://github.com/Que20/UIDrawer.git', :tag => '1.0'
  pod 'QCropper'
end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
 end
 end
end

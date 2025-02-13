workspace "NevisExampleApp"
project "NevisExampleApp.xcodeproj"

use_frameworks!

ios_deployment_target = "12.0".freeze

target "NevisExampleApp" do
	platform :ios, ios_deployment_target

	pod "FittedSheets", "= 2.7.1"
	pod "KRProgressHUD", "= 3.4.7"
	pod "MercariQRScanner", "= 1.9.0"
	pod "Reusable", "= 4.1.2"
	pod "RxCocoa", "= 6.8.0"
	pod "RxSwift", "= 6.8.0"
	pod "Swinject", "= 2.9.1"
	pod "SwinjectAutoregistration", "= 2.9.1"
	pod "Then", "= 3.0.0"
	pod "NevisMobileAuthentication", "~> 3.8.1", :configurations => ["Release"]
	pod "NevisMobileAuthentication-Debug", "~> 3.8.1", :configurations => ["Debug"]
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = ios_deployment_target
			config.build_settings["ENABLE_BITCODE"] = "NO" # NMA SDK does not support Bitcode
		end
	end
end

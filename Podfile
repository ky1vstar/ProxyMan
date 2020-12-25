platform :ios, '13.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

target 'Proxyman' do
	pod 'R.swift'
    pod 'Swinject'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        # https://stackoverflow.com/a/64048124/5089731
        target.build_configurations.each do |config|
            config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        end
    end
end
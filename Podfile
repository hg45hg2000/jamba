# Uncomment this line to define a global platform for your project
 platform :ios, '8.1'
# Uncomment this line if you're using Swift
 use_frameworks!

pod 'RealmSwift'
target 'TaipeiTrackRubbishTruck' do
    
pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'Alamofire', '~> 3.5'
pod 'Firebase'
pod 'Firebase/Messaging'
pod 'Firebase/Crash'
pod 'Firebase/Core'
#pod 'ObjectMapper', '~> 1.3'
pod 'AlamofireObjectMapper', '~> 3.0'
end

target 'TaipeiTrackRubbishTruckTests' do
pod 'Firebase'
pod 'GoogleMaps'
end

target 'TaipeiTrackRubbishTruckUITests' do

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end

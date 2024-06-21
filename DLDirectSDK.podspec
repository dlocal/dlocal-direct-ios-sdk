Pod::Spec.new do |spec|
    spec.name         = 'DLDirectSDK'
    spec.version      = '3.0.5'
    spec.authors      = { 'dLocal' => 'mobile-dev@dlocal.com' }
    spec.homepage     = "https://github.com/dlocal/dlocal-direct-ios-sdk/"
    spec.summary      = 'dLocal Direct iOS SDK'
    spec.source       = { :http => "https://github.com/dlocal/dlocal-direct-ios-sdk/releases/download/v#{spec.version.to_s}/DLDirectSDK-#{spec.version.to_s}.zip" }
    spec.license      = { :type => 'MIT', :file => 'LICENSE.md' }
    spec.platform     = :ios
    spec.ios.deployment_target = '13.0'
    spec.ios.vendored_frameworks = "DLDirectSDK.xcframework"
end

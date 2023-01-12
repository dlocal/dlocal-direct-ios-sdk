Pod::Spec.new do |spec|
    spec.name         = 'DLDirectSDK'
    spec.version      = '0.2.7'
    spec.authors      = { 'dLocal' => 'mobile-dev@dlocal.com' }
    spec.homepage     = "https://github.com/dlocal/dlocal-direct-ios-sdk"
    spec.summary      = 'Wrapper for dLocal API'
    spec.source       = { :http => "https://github.com/dlocal/dlocal-direct-ios-sdk/blob/#{spec.version.to_s}/DLDirectSDK.zip?raw=true" }
    spec.license      = { :type => 'MIT', :file => 'LICENSE.md' }
    spec.platform     = :ios
    spec.ios.deployment_target = '13.0'
    spec.ios.vendored_frameworks = "DLDirectSDK.xcframework"
end

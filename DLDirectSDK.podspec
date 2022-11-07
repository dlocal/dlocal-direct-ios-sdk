Pod::Spec.new do |spec|
    spec.name         = 'DLDirectSDK'
    spec.version      = '0.1.11'
    spec.authors      = { 'dLocal' => 'mobile-dev@dlocal.com' }
    spec.homepage     = "https://bitbucket.org/dlocal-public/dlocal-direct-ios-sdk/"
    spec.summary      = 'Wrapper for dLocal API'
    spec.source       = { :http => "https://bitbucket.org/dlocal-public/dlocal-direct-ios-sdk/downloads/DLDirectSDK-#{spec.version.to_s}.zip" }
    spec.license      = { :type => 'MIT', :file => 'LICENSE.md' }
    spec.platform     = :ios
    spec.ios.deployment_target = '13.0'
    spec.ios.vendored_frameworks = "DLDirectSDK.xcframework"
end

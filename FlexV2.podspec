require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))
folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'

Pod::Spec.new do |s|
  s.name             = "FlexV2"
  s.version          = package["version"]
  s.summary          = package["description"]
  s.homepage         = package["homepage"]
  s.license          = package["license"]
  s.authors          = package["author"]

  s.platform         = :ios, "16.0"
  s.source           = { :git => "https://github.com/divemulapa/react-native-flex-v2.git", :tag => "#{s.version}" }

  s.source_files     = "ios/**/*.{h,swift}"
  s.dependency       "flex-api-ios-sdk"
  s.swift_version    = "5.0"

  # Disable header maps to avoid name conflicts with React Native's Base64.h
  s.pod_target_xcconfig ||= {}
  s.pod_target_xcconfig['USE_HEADERMAP']     = 'NO'
  s.pod_target_xcconfig['DEFINES_MODULE']   = 'YES'

  if respond_to?(:install_modules_dependencies, true)
    install_modules_dependencies(s)
  else
    s.dependency "React-Core"

    if ENV['RCT_NEW_ARCH_ENABLED'] == '1'
      s.compiler_flags = folly_compiler_flags + " -DRCT_NEW_ARCH_ENABLED=1"
      s.pod_target_xcconfig.merge!({
        "HEADER_SEARCH_PATHS"           => "\"$(PODS_ROOT)/Headers/Public/flex_api_ios_sdk\"",
        "OTHER_CPLUSPLUSFLAGS"          => folly_compiler_flags,
        "CLANG_CXX_LANGUAGE_STANDARD"   => "c++17"
      })
      s.dependency "React-Codegen"
      s.dependency "RCT-Folly"
      s.dependency "RCTRequired"
      s.dependency "RCTTypeSafety"
      s.dependency "ReactCommon/turbomodule/core"
    end
  end
end

use_frameworks!
install! 'cocoapods', :share_schemes_for_development_pods => true
platform :ios, '11.0'
project 'FastMath.xcodeproj'
workspace 'FastMath.xcworkspace'

target 'FastMathTestHarness' do
  pod 'FastMath', :path => '.', :testspecs => ['Tests']
  pod 'Pippin/Extensions', :path => '../Pippin'
end

use_frameworks!
install! 'cocoapods', :share_schemes_for_development_pods => true
project 'FastMath.xcodeproj'
workspace 'FastMath.xcworkspace'

abstract_target 'FastMathTestHarnessPods' do
  pod 'FastMath', :path => '.', :testspecs => ['Tests']
  pod 'Pippin/Extensions'
  
  target 'FastMathTestHarness' do
    platform :ios, '11.0'
  end
  target 'FastMathTestHarness-macOS' do
    platform :osx, '10.14'
  end
end

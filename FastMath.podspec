Pod::Spec.new do |s|
  s.name         = 'FastMath'
  s.version      = '3.0.1'
  s.summary      = "A math library written in Swift."
  s.description  = <<-DESC
                    FastMath is a framework for performing numerical computation in Swift.
                   DESC
  s.homepage     = "https://github.com/tworingsoft/fastmath"
  s.license      = "MIT"
  s.author             = { "Andrew McKnight" => "andrew@tworingsoft.com" }
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.12'
  s.source       = { :git => "https://github.com/tworingsoft/fastmath.git", :tag => "#{s.version}" }
  s.source_files  = "Sources/**/*.{c,h,swift}"
  s.swift_version = '5'
  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/**/*.swift'
  end
  s.dependency 'PippinLibrary', '~> 1'
end

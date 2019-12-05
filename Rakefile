def ruby_environment_prefixes
    user = `whoami`.strip
    if user == 'travis' then
        ''
    else
        'rbenv exec'
    end
end

desc 'Initialize development environment.'
task :init do
    sh 'brew update'
    sh 'brew tap tworingsoft/formulae'
    [ 'vrsn' ].each do |formula|
        sh "brew install #{formula} || brew upgrade #{formula}"
    end
    sh "#{ruby_environment_prefixes} gem install xcpretty"
    sh "#{ruby_environment_prefixes} pod install --repo-update --verbose"
end

desc 'Run unit and UI tests.'
task :test do
    require 'open3'

    scheme = 'FastMath-Unit-Tests'
    Open3.pipeline(
       ["xcrun xcodebuild -workspace FastMath.xcworkspace -scheme #{scheme} -destination 'platform=iOS Simulator,name=iPhone SE,OS=12.1' test"],
       ["tee #{scheme}.log"],
       ['#{ruby_environment_prefixes} xcpretty -t']
   )
end

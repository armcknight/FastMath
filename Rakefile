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
       ["xcrun xcodebuild -workspace FastMath.xcworkspace -scheme #{scheme} -destination 'platform=iOS Simulator,name=iPhone SE,OS=11.4' test"],
       ["tee #{scheme}.log"],
       ['#{ruby_environment_prefixes} xcpretty -t']
   )
end

version_file = 'FastMath.podspec'

desc 'Bump version number and commit the changes with message as the output from vrsn. Can supply argument to bump one of: major, minor, patch or build. E.g., `rake bump[major]` or `rake bump[build]`.'
task :bump,[:component] do |t, args|
    require 'open3'

    modified_file_count, stderr, status = Open3.capture3("git status --porcelain | egrep '^(M| M)' | wc -l")
    if modified_file_count.to_i > 0 then
        sh "git stash"
    end

    component = args[:component]
    if component == 'major' then
        stdout, stderr, status = Open3.capture3("vrsn major --file #{version_file}")
    elsif component == 'minor' then
        stdout, stderr, status = Open3.capture3("vrsn minor --file #{version_file}")
    elsif component == 'patch' then
        stdout, stderr, status = Open3.capture3("vrsn patch --file #{version_file}")
    elsif component == 'build' then
        stdout, stderr, status = Open3.capture3("vrsn --numeric --file #{version_file}")
    else
        fail 'Unrecognized version component.'
    end

    sh "git add #{version_file}"
    sh "git commit --message \"#{stdout}\""

    if modified_file_count.to_i > 0 then
        sh "git stash pop"
    end
end

desc 'Perform tasks necessary to release a new version of the app.'
task :release do
  version = `vrsn --read --file #{version_file}`
  sh "git tag #{version.strip}"
  sh 'git push --tags'
  
  sh "pod trunk push #{version_file} --allow-warnings"
end

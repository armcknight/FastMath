build: build-phone build-mac

build-phone:
	xcodebuild -workspace FastMath.xcworkspace -scheme FastMathTestHarness -sdk iphoneos -quiet clean build

build-mac:
	xcodebuild -workspace FastMath.xcworkspace -scheme FastMathTestHarness-macOS -sdk macosx -quiet clean build

prerelease:
	rbenv exec bundle exec prerelease-podspec FastMath --allow-warnings --skip-tests

release:
	rbenv exec bundle exec release-podspec FastMath --repo tworingsoft --allow-warnings --skip-tests

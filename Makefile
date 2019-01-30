build: build-phone build-mac

build-phone:
	xcodebuild -workspace FastMath.xcworkspace -scheme FastMathTestHarness -sdk iphoneos -quiet clean build

build-mac:
	xcodebuild -workspace FastMath.xcworkspace -scheme FastMathTestHarness-macOS -sdk macosx -quiet clean build

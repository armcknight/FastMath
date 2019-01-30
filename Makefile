build: build-phone build-mac

build-phone:
	xcodebuild -workspace FastMath.xcworkspace -scheme FastMathTestHarness -sdk iphoneos -quiet

build-mac:
	xcodebuild -workspace FastMath.xcworkspace -scheme FastMathTestHarness-macOS -sdk macosx -quiet
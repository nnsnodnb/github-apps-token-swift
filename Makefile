.PHONY: debug_build
debug_build:
	@swift build -c debug

.PHONY: release_build
release_build:
	@swift build -c release --arch arm64
	@swift build -c release --arch x86_64
	@mkdir -p dist
	@lipo -create .build/arm64-apple-macosx/release/github-apps-token .build/x86_64-apple-macosx/release/github-apps-token -output dist/github-apps-token
	@strip dist/github-apps-token

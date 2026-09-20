.PHONY: debug_build
debug_build:
	@swift build -c debug

.PHONY: release_build
release_build:
	@swift build -c release --arch arm64
	@mkdir -p dist
	@cp .build/out/Products/Release/github-apps-token dist/
	@strip dist/github-apps-token

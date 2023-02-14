.PHONY: debug_build
debug_build:
	@swift build -c debug

.PHONY: release_build
release_build:
	@swift build --disable-sandbox -c release --arch arm64 --arch x86_64

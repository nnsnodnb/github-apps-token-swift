.PHONY: debug_build
debug_build:
	@swift build -c debug

.PHONY: release_build
release_build:
	@swift build --disable-sandbox -c release --arch arm64 --arch x86_64

.PHONY: docker_image
docker_image:
	@docker build --platform linux/amd64 --force-rm --tag github-apps-token .

.PHONY: linux_zip
linux_zip: docker_image
	@$(eval TMP_FOLDER := $(shell mktemp -d))
	@docker run github-apps-token cat /usr/bin/github-apps-token > "$(TMP_FOLDER)/github-apps-token"
	chmod +x "$(TMP_FOLDER)/github-apps-token"
	cp -f "$(LICENSE_PATH)" "$(TMP_FOLDER)"
	(cd "$(TMP_FOLDER)"; zip -yr - "github-apps-token" "LICENSE") > "./github-apps-token-linux.zip"

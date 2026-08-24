ARG BUILDER_IMAGE=ghcr.io/nnsnodnb/swift-static-linux-sdk:6.3.3-bookworm
ARG RUNTIME_IMAGE=ubuntu:26.04

FROM ${BUILDER_IMAGE} AS builder

WORKDIR /workdir/
COPY Sources Sources/
COPY Tests Tests/
COPY Package.* ./

RUN swift package resolve

ARG SWIFT_FLAGS="--swift-sdk aarch64-swift-linux-musl --swift-sdk x86_64-swift-linux-musl -c release"
RUN swift build $SWIFT_FLAGS --product github-apps-token
RUN mv `swift build $SWIFT_FLAGS --show-bin-path`/github-apps-token /usr/bin

# Runtime image
FROM ${RUNTIME_IMAGE}
COPY --from=builder /usr/bin/github-apps-token /usr/bin

RUN github-apps-token --version

CMD ["github-apps-token"]

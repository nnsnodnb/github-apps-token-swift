ARG BUILDER_IMAGE=swift:6.0.1-jammy
ARG RUNTIME_IMAGE=ubuntu:noble

FROM ${BUILDER_IMAGE} AS builder

WORKDIR /workdir/
COPY Sources Sources/
COPY Tests Tests/
COPY Package.* ./

RUN swift package resolve

ARG SWIFT_STATIC_LINUX_SDK=https://download.swift.org/swift-6.0.1-release/static-sdk/swift-6.0.1-RELEASE/swift-6.0.1-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz
ARG SWIFT_STATIC_LINUX_SDK_CHECKSUM=d4f46ba40e11e697387468e18987ee622908bc350310d8af54eb5e17c2ff5481

RUN swift sdk install $SWIFT_STATIC_LINUX_SDK --checksum $SWIFT_STATIC_LINUX_SDK_CHECKSUM
ARG SWIFT_FLAGS="--swift-sdk aarch64-swift-linux-musl --swift-sdk x86_64-swift-linux-musl"
RUN swift build $SWIFT_FLAGS --product github-apps-token
RUN mv `swift build $SWIFT_FLAGS --show-bin-path`/github-apps-token /usr/bin

# Runtime image
FROM ${RUNTIME_IMAGE}
COPY --from=builder /usr/bin/github-apps-token /usr/bin

RUN github-apps-token --version

CMD ["github-apps-token"]

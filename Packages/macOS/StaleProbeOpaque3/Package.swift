// swift-tools-version: 6.0

// Fleet probe (not for merge): does a warm .build rebuild a test target whose
// dependency's dependency changed? ProbeTests imports ProbeCore only through
// ProbeMiddle, and no declaration of ProbeMiddle names a ProbeCore type, so
// ProbeMiddle's .swiftmodule has the same bytes whatever ProbeCore's init is.
import PackageDescription

let package = Package(
    name: "StaleProbeOpaque3",
    platforms: [.macOS(.v14)],
    targets: [
        .target(name: "ProbeCore"),
        .target(name: "ProbeMiddle", dependencies: ["ProbeCore"]),
        .testTarget(name: "ProbeTests", dependencies: ["ProbeMiddle"]),
    ]
)

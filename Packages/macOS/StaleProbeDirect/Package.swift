// swift-tools-version: 6.0

// Fleet probe (not for merge): does a warm .build rebuild a test target whose
// dependency's dependency changed? ProbeTests lists ProbeCore directly (the control).
import PackageDescription

let package = Package(
    name: "StaleProbeDirect",
    platforms: [.macOS(.v14)],
    targets: [
        .target(name: "ProbeCore"),
        .target(name: "ProbeMiddle", dependencies: ["ProbeCore"]),
        .testTarget(name: "ProbeTests", dependencies: ["ProbeCore", "ProbeMiddle"]),
    ]
)

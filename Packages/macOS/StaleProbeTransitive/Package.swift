// swift-tools-version: 6.0

// Fleet probe (not for merge): does a warm .build rebuild a test target whose
// dependency's dependency changed? ProbeTests imports ProbeCore only through ProbeMiddle, as CmuxNextPaletteTests imports CmuxNextActions.
import PackageDescription

let package = Package(
    name: "StaleProbeTransitive",
    platforms: [.macOS(.v14)],
    targets: [
        .target(name: "ProbeCore"),
        .target(name: "ProbeMiddle", dependencies: ["ProbeCore"]),
        .testTarget(name: "ProbeTests", dependencies: ["ProbeMiddle"]),
    ]
)

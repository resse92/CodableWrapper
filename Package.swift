// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "CodableWrapper",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13), .visionOS(.v1)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CodableWrapper",
            targets: ["CodableWrapper"]
        ),
    ],
    dependencies: [
        // Depend on the latest Swift 5.9 SwiftSyntax
        // .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", exact: "510.0.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "CodableWrapperMacros",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftOperators", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftParserDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "CodableWrapper",
                dependencies: ["CodableWrapperMacros"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "CodableWrapperTests",
            dependencies: [
                "CodableWrapper",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)


//var unusedDeps: Set<String> = []
//var includeTargets: Set<String> = []
//var includeProducts: Set<String> = []
//
//if Context.environment["METACODABLE_BEING_USED_FROM_COCOAPODS"] != nil { // CocoaPods specific
//    unusedDeps.formUnion(["swift-format", "swift-docc-plugin"])
//    includeTargets.formUnion(["PluginCore", "MacroPlugin"])
//    includeProducts.insert("MacroPlugin")
//    package.products.append(.executable(name: "MacroPlugin", targets: ["MacroPlugin"]))
//    package.targets = package.targets.compactMap { target in
//        guard target.type == .macro else { return target }
//        return .executableTarget(
//            name: target.name,
//            dependencies: target.dependencies,
//            path: target.path,
//            exclude: target.exclude,
//            sources: target.sources,
//            resources: target.resources,
//            publicHeadersPath: target.publicHeadersPath,
//            cSettings: target.cSettings,
//            cxxSettings: target.cxxSettings,
//            swiftSettings: target.swiftSettings,
//            linkerSettings: target.linkerSettings,
//            plugins: target.plugins
//        )
//    }
//
//    if Context.environment["METACODABLE_COCOAPODS_PROTOCOL_PLUGIN"] != nil {
//        includeTargets.insert("ProtocolGen")
//        includeProducts.insert("ProtocolGen")
//        package.products.append(
//            .executable(name: "ProtocolGen", targets: ["ProtocolGen"])
//        )
//    } else {
//        unusedDeps.insert("swift-argument-parser")
//    }
//} else if Context.environment["METACODABLE_CI"] == nil { // SPM specific
//    unusedDeps.insert("swift-format")
//    package.targets.removeAll { $0.name == "MetaCodableTests" }
//    package.targets.append(
//        .testTarget(
//            name: "MetaCodableTests",
//            dependencies: [
//                "PluginCore", "MacroPlugin", "MetaCodable", "HelperCoders",
//                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
//            ],
//            plugins: ["MetaProtocolCodable"]
//        )
//    )
//
//    if Context.environment["SPI_GENERATE_DOCS"] == nil {
//        unusedDeps.insert("swift-docc-plugin")
//    }
//}

//package.dependencies.removeAll { unusedDeps.contains($0.kind.repoName ?? "") }
//
//if !includeTargets.isEmpty {
//    package.targets.removeAll { !includeTargets.contains($0.name) }
//}
//
//if !includeProducts.isEmpty {
//    package.products.removeAll { !includeProducts.contains($0.name) }
//}
//if Context.environment["METACODABLE_BEING_USED_FROM_COCOAPODS"] != nil { // CocoaPods specific
//    unusedDeps.formUnion(["swift-format", "swift-docc-plugin"])
//    includeTargets.formUnion(["CodableWrapperMacroPlugin"])
//    includeProducts.insert("CodableWrapperMacroPlugin")
//    package.products.append(.executable(name: "CodableWrapperMacroPlugin", targets: ["CodableWrapperMacroPlugin"]))
//    package.targets = package.targets.compactMap { target in
//        guard target.type == .macro else { return target }
//        return .executableTarget(
//            name: target.name,
//            dependencies: target.dependencies,
//            path: target.path,
//            exclude: target.exclude,
//            sources: target.sources,
//            resources: target.resources,
//            publicHeadersPath: target.publicHeadersPath,
//            cSettings: target.cSettings,
//            cxxSettings: target.cxxSettings,
//            swiftSettings: target.swiftSettings,
//            linkerSettings: target.linkerSettings,
//            plugins: target.plugins
//        )
//    }
//
//    if Context.environment["METACODABLE_COCOAPODS_PROTOCOL_PLUGIN"] != nil {
//        includeTargets.insert("ProtocolGen")
//        includeProducts.insert("ProtocolGen")
//        package.products.append(
//            .executable(name: "ProtocolGen", targets: ["ProtocolGen"])
//        )
//    } else {
//        unusedDeps.insert("swift-argument-parser")
//    }
//} 
//
//package.dependencies.removeAll { unusedDeps.contains($0.kind.repoName ?? "") }
//
//if !includeTargets.isEmpty {
//    package.targets.removeAll { !includeTargets.contains($0.name) }
//}
//
//if !includeProducts.isEmpty {
//    package.products.removeAll { !includeProducts.contains($0.name) }
//}

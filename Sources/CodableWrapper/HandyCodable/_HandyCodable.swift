// CodableWrapper
// Created by: resse

import Foundation
#if canImport(HandyJSON)

public var isInExp: Bool = true

// MARK: - HandyCodable Macro
@attached(member, names: named(init(from:)), named(encode(to:)), arbitrary)
@attached(extension, conformances: _HandyCodable)
public macro HandyCodable() = #externalMacro(module: "CodableWrapperMacros", type: "HandyCodable")

@attached(member, names: named(init(from:)), named(encode(to:)), arbitrary)
@attached(extension, conformances: _HandyCodable)
public macro HandyCodableSubclass() = #externalMacro(module: "CodableWrapperMacros", type: "HandyCodableSubclass")


import HandyJSON

// MARK: - HandyCodable
public protocol _HandyCodable: HandyJSON, Codable { }
#endif


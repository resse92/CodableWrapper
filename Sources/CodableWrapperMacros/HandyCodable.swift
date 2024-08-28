// CodableWrapper
// Created by: resse

import SwiftSyntax
import SwiftSyntaxMacros

public struct HandyCodable: ExtensionMacro, MemberMacro {
    public static func expansion(of node: AttributeSyntax,
                                 attachedTo declaration: some DeclGroupSyntax,
                                 providingExtensionsOf type: some TypeSyntaxProtocol,
                                 conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        var inheritedTypes: InheritedTypeListSyntax?
        if let declaration = declaration.as(StructDeclSyntax.self) {
            inheritedTypes = declaration.inheritanceClause?.inheritedTypes
        } else if let declaration = declaration.as(ClassDeclSyntax.self) {
            inheritedTypes = declaration.inheritanceClause?.inheritedTypes
        } else {
            throw ASTError("use @HandyCodable in `struct` or `class`")
        }
        if let inheritedTypes = inheritedTypes,
           inheritedTypes.contains(where: { inherited in ["Codable", "_HandyCodable"].contains(inherited.type.trimmedDescription) }) {
            return []
        }

        let ext: DeclSyntax =
            """
            extension \(type.trimmed): _HandyCodable {}
            """

        return [ext.cast(ExtensionDeclSyntax.self)]
    }

    public static func expansion(of node: SwiftSyntax.AttributeSyntax,
                                 providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
                                 in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {

        let propertyContainer = try ModelMemberPropertyContainer(decl: declaration, context: context, isHandyJSON: true)
        let decoder = try propertyContainer.genDecoderInitializer(config: .init(isOverride: false))
        let encoder = try propertyContainer.genEncodeFunction(config: .init(isOverride: false))

        return [decoder, encoder]
    }
}

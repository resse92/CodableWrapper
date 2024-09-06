// CodableWrapper
// Created by: resse

import Foundation

// MARK: - HandyCodable Macro
@attached(member, names: named(init(from:)), named(encode(to:)), arbitrary)
@attached(extension, conformances: _HandyCodable)
public macro HandyCodable() = #externalMacro(module: "CodableWrapperMacros", type: "HandyCodable")

#if canImport(HandyJSON)
import HandyJSON

// MARK: - HandyCodable
public protocol _HandyCodable: HandyJSON, Codable { }

// MARK: - HandyJSONTransform
// HandyJSON 的transform转成 CodableWrapper.Transform
public class HandyJSONTransform<T: __HandyJSONTransform> {
    
    let handyTransform: T
    public init(transform: T) {
        self.handyTransform = transform
    }
}

extension HandyJSONTransform: CodableWrapper.TransformType where T.JSON: Codable {
    
    public typealias Object = Optional<T.Object>
    public typealias JSON = T.JSON
    
    public func transformFromJSON(_ json: JSON?) -> Object {
        self.handyTransform.transformFromJSON(json)
    }
    
    public func transformToJSON(_ object: Object) -> JSON? {
        self.handyTransform.transformToJSON(object)
    }
}
#else

public protocol _HandyCodable: Codable {
    init()
    mutating func willStartMapping()
    mutating func mapping(mapper: HelpingMapper)
    mutating func didFinishMapping()
}

extension _HandyCodable {
    public func willStartMapping() { }
    func mapping(mapper: HelpingMapper) { }
    public func didFinishMapping() { }
}


public typealias CustomMappingKeyValueTuple = (Int, MappingPropertyHandler)

struct MappingPath {
    var segments: [String]

    static func buildFrom(rawPath: String) -> MappingPath {
        let regex = try! NSRegularExpression(pattern: "(?<![\\\\])\\.")
        let nsString = rawPath as NSString
        let results = regex.matches(in: rawPath, range: NSRange(location: 0, length: nsString.length))
        var splitPoints = results.map { $0.range.location }

        var curPos = 0
        var pathArr = [String]()
        splitPoints.append(nsString.length)
        splitPoints.forEach({ (point) in
            let start = rawPath.index(rawPath.startIndex, offsetBy: curPos)
            let end = rawPath.index(rawPath.startIndex, offsetBy: point)
            let subPath = String(rawPath[start ..< end]).replacingOccurrences(of: "\\.", with: ".")
            if !subPath.isEmpty {
                pathArr.append(subPath)
            }
            curPos = point + 1
        })
        return MappingPath(segments: pathArr)
    }
}

extension Dictionary where Key == String, Value: Any {

    func findValueBy(path: MappingPath) -> Any? {
        var currentDict: [String: Any]? = self
        var lastValue: Any?
        path.segments.forEach { (segment) in
            lastValue = currentDict?[segment]
            currentDict = currentDict?[segment] as? [String: Any]
        }
        return lastValue
    }
}

public class MappingPropertyHandler {
    var mappingPaths: [MappingPath]?
    var assignmentClosure: ((Any?) -> (Any?))?
    var takeValueClosure: ((Any?) -> (Any?))?
    
    public init(rawPaths: [String]?, assignmentClosure: ((Any?) -> (Any?))?, takeValueClosure: ((Any?) -> (Any?))?) {
        let mappingPaths = rawPaths?.map({ (rawPath) -> MappingPath in
            return MappingPath.buildFrom(rawPath: rawPath)
        }).filter({ (mappingPath) -> Bool in
            return mappingPath.segments.count > 0
        })
        if let count = mappingPaths?.count, count > 0 {
            self.mappingPaths = mappingPaths
        }
        self.assignmentClosure = assignmentClosure
        self.takeValueClosure = takeValueClosure
    }
}

/// all blow code for type check, and never be called in runtime

public class HelpingMapper {
    
    private var mappingHandlers = [Int: MappingPropertyHandler]()
    private var excludeProperties = [Int]()
    
    internal func getMappingHandler(key: Int) -> MappingPropertyHandler? {
        return self.mappingHandlers[key]
    }
    
    internal func propertyExcluded(key: Int) -> Bool {
        return self.excludeProperties.contains(key)
    }
    
    public func specify<T>(property: inout T, name: String? = nil, converter: ((String) -> T)? = nil) { }
    
    public func exclude<T>(property: inout T) {
        self._exclude(property: &property)
    }
    
    fileprivate func addCustomMapping(key: Int, mappingInfo: MappingPropertyHandler) {
        self.mappingHandlers[key] = mappingInfo
    }
    
    fileprivate func _exclude<T>(property: inout T) {
        let pointer = withUnsafePointer(to: &property, { return $0 })
        self.excludeProperties.append(Int(bitPattern: pointer))
    }
}

infix operator <-- : LogicalConjunctionPrecedence

public func <-- <T>(property: inout T, name: String) -> CustomMappingKeyValueTuple {
    return property <-- [name]
}

public func <-- <T>(property: inout T, names: [String]) -> CustomMappingKeyValueTuple {
    return (0, MappingPropertyHandler(rawPaths: [], assignmentClosure: nil, takeValueClosure: nil))
}

// MARK: non-optional properties
public func <-- <Transform: TransformType>(property: inout Transform.Object, transformer: Transform) -> CustomMappingKeyValueTuple {
    return property <-- (nil, transformer)
}

public func <-- <Transform: TransformType>(property: inout Transform.Object, transformer: (String?, Transform?)) -> CustomMappingKeyValueTuple {
    let names = (transformer.0 == nil ? [] : [transformer.0!])
    return property <-- (names, transformer.1)
}

public func <-- <Transform: TransformType>(property: inout Transform.Object, transformer: ([String], Transform?)) -> CustomMappingKeyValueTuple {
    (0, MappingPropertyHandler(rawPaths: [], assignmentClosure: nil, takeValueClosure: nil))
}

// MARK: optional properties
public func <-- <Transform: TransformType>(property: inout Transform.Object?, transformer: Transform) -> CustomMappingKeyValueTuple {
    return property <-- (nil, transformer)
}

public func <-- <Transform: TransformType>(property: inout Transform.Object?, transformer: (String?, Transform?)) -> CustomMappingKeyValueTuple {
    let names = (transformer.0 == nil ? [] : [transformer.0!])
    return property <-- (names, transformer.1)
}

public func <-- <Transform: TransformType>(property: inout Transform.Object?, transformer: ([String], Transform?)) -> CustomMappingKeyValueTuple {
    (0, MappingPropertyHandler(rawPaths: [], assignmentClosure: nil, takeValueClosure: nil))
}

infix operator <<< : AssignmentPrecedence

public func <<< (mapper: HelpingMapper, mapping: CustomMappingKeyValueTuple) {
    mapper.addCustomMapping(key: mapping.0, mappingInfo: mapping.1)
}

public func <<< (mapper: HelpingMapper, mappings: [CustomMappingKeyValueTuple]) {
    mappings.forEach { (mapping) in
        mapper.addCustomMapping(key: mapping.0, mappingInfo: mapping.1)
    }
}

infix operator >>> : AssignmentPrecedence

public func >>> <T> (mapper: HelpingMapper, property: inout T) {
    mapper._exclude(property: &property)
}

#endif

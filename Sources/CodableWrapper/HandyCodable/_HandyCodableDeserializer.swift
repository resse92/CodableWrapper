//
//  File.swift
//  
//
//  Created by resse.zhu on 2024/8/28.
//

import Foundation
#if canImport(HandyJSON)
import HandyJSON

//public extension _HandyCodable {
//
//    /// Finds the internal dictionary in `dict` as the `designatedPath` specified, and converts it to a Model
//    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
//    static func deserialize(from dict: NSDictionary?, designatedPath: String? = nil) -> Self? {
//        return deserialize(from: dict as? [String: Any], designatedPath: designatedPath)
//    }
//
//    /// Finds the internal dictionary in `dict` as the `designatedPath` specified, and converts it to a Model
//    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
//    static func deserialize(from dict: [String: Any]?, designatedPath: String? = nil) -> Self? {
//        return JSONDeserializer<Self>.deserializeFrom(dict: dict, designatedPath: designatedPath)
//    }
//
//    /// Finds the internal JSON field in `json` as the `designatedPath` specified, and converts it to a Model
//    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
//    static func deserialize(from json: String?, designatedPath: String? = nil) -> Self? {
//        return JSONDeserializer<Self>.deserializeFrom(json: json, designatedPath: designatedPath)
//    }
//}
//
//public extension Array where Element: _HandyCodable {
//
//    /// if the JSON field finded by `designatedPath` in `json` is representing a array, such as `[{...}, {...}, {...}]`,
//    /// this method converts it to a Models array
//    static func deserialize(from json: String?, designatedPath: String? = nil) -> [Element?]? {
//        return JSONDeserializer<Element>.deserializeModelArrayFrom(json: json, designatedPath: designatedPath)
//    }
//
//    /// deserialize model array from NSArray
//    static func deserialize(from array: NSArray?) -> [Element?]? {
//        return JSONDeserializer<Element>.deserializeModelArrayFrom(array: array)
//    }
//
//    /// deserialize model array from array
//    static func deserialize(from array: [Any]?) -> [Element?]? {
//        return JSONDeserializer<Element>.deserializeModelArrayFrom(array: array)
//    }
//}
#endif

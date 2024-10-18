//
//  File.swift
//  CodableWrapper
//
//  Created by resse.zhu on 2024/10/15.
//

import Foundation
//#if canImport(HandyJSON)
//import HandyJSON

struct _HandyLogger {

    static func logError(_ items: Any..., separator: String = " ", terminator: String = "\n") {
//        if HandyJSONConfiguration.debugMode.rawValue <= DebugMode.error.rawValue {
//            print(items, separator: separator, terminator: terminator)
//        }
    }

    static func logDebug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
//        if HandyJSONConfiguration.debugMode.rawValue <= DebugMode.debug.rawValue {
//            print(items, separator: separator, terminator: terminator)
//        }
    }

    static func logVerbose(_ items: Any..., separator: String = " ", terminator: String = "\n") {
//        if HandyJSONConfiguration.debugMode.rawValue <= DebugMode.verbose.rawValue {
//            print(items, separator: separator, terminator: terminator)
//        }
    }
}
//#endif

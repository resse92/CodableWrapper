//
//  File.swift
//  
//
//  Created by resse.zhu on 2024/8/28.
//

import Foundation

#if canImport(HandyJSON)
import HandyJSON

public enum _HandyCodableError: Error {
    case encodeError
}

public extension _HandyCodable {

    func toJSON() -> [String: Any]? {
        if isInExp {
            let data = try? JSONEncoder().encode(self)
            let dict = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
            return dict
        } else {
            let this = self as HandyJSON
            return this.toJSON()
        }
    }

    func toJSONString(prettyPrint: Bool = false) -> String? {
        if isInExp {
            if let data = try? JSONEncoder().encode(self) {
                return String(data: data, encoding: .utf8)
            }
            assert(false, "Failed to encode \(self) to JSON String")
            return nil
        } else {
            let this = self as HandyJSON
            return this.toJSONString(prettyPrint: prettyPrint)
        }
    }
}

public extension Collection where Iterator.Element: _HandyCodable {

    func toJSON() -> [[String: Any]?] {
        return self.map { $0.toJSON() }
    }

    func toJSONString(prettyPrint: Bool = false) -> String? {
        let anyArray = self.toJSON()
        if JSONSerialization.isValidJSONObject(anyArray) {
            do {
                let jsonData: Data
                if prettyPrint {
                    jsonData = try JSONSerialization.data(withJSONObject: anyArray, options: [.prettyPrinted])
                } else {
                    jsonData = try JSONSerialization.data(withJSONObject: anyArray, options: [])
                }
                return String(data: jsonData, encoding: .utf8)
            } catch let error {
                _HandyLogger.logError(error)
            }
        } else {
            _HandyLogger.logDebug("\(self.toJSON()) is not a valid JSON Object")
        }
        return nil
    }
}

#endif

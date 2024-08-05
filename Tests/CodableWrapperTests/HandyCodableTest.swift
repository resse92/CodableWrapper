// CodableWrapper
// Created by: resse

import CodableWrapper
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

//open class DateTransform: TransformType {
//    public typealias Object = Date
//    public typealias JSON = Double
//
//    public init() {}
//
//    public func transformFromJSON(_ value: JSON?) -> Date? {
//        if let timeInt = value as? Double {
//            return Date(timeIntervalSince1970: TimeInterval(timeInt))
//        }
//
//        if let timeStr = value as? String {
//            return Date(timeIntervalSince1970: TimeInterval(atof(timeStr)))
//        }
//
//        return nil
//    }
//
//    public func transformToJSON(_ value: Date?) -> Double? {
//        if let date = value {
//            return Double(date.timeIntervalSince1970)
//        }
//        return nil
//    }
//}

// 为什么这里获取不到HandyCodable
@HandyCodable
struct HandyCodableModel {
    var s: String = ""
    var date: Date = Date()
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            s <-- "abcdefg"
//        mapper <<<
//            date <-- ("ABC", DateTransform.init())
    }
}

extension HandyCodableModel {
    init() {
        let mapping = HelpingMapper()
        mapping(mapper: mapping)
        
    }
}

final class HandyCodableTest: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHashable() throws {
        let a = HashableModel(value1: "abc")
        let b = HashableModel(value1: "abc")

        let c = NavtiveHashableModel(value1: "abc")
        let d = NavtiveHashableModel2(value1: "abc")

        XCTAssertEqual(a.hashValue, b.hashValue)
        XCTAssertEqual(a.hashValue, c.hashValue)
        XCTAssertEqual(c.hashValue, d.hashValue)
    }
}

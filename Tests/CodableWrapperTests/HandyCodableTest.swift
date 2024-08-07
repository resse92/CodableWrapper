// CodableWrapper
// Created by: resse

import CodableWrapper
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

open class DateTransform: TransformType {
    
    
    public typealias Object = Date
    public typealias JSON = Double

    public init() {}

    public func transformFromJSON(_ json: JSON?) -> Date {
        if let timeInt = json {
            return Date(timeIntervalSince1970: TimeInterval(timeInt))
        }

        return Date()
    }

    public func transformToJSON(_ object: Date) -> Double? {
        Double(object.timeIntervalSince1970)
    }
}

@HandyCodable
struct HandyCodableModel {
    var s: String = ""
    var date: Date = Date()
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            s <-- "s1"
        mapper <<<
            date <-- ("date", DateTransform())
    }
}

struct Test: Codable {
    var s1: String
    var s2: String
    var i1: Int
    var f1: Float
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.s1 = try container.decode(String.self, forKey: .s1)
        self.s2 = try container.decode(String.self, forKey: .s2)
        self.i1 = try container.decode(Int.self, forKey: .i1)
        self.f1 = try container.decode(Float.self, forKey: .f1)
    }
}

//extension HandyCodableModel {
//    init(from deocder: Decoder) throws {
//        let mapping = HelpingMapper()
//        self.mapping(mapper: mapping)
//        self.willStartMapping()
//        self.s = decoder.decode(type: String.self, keys: nil, nestedKeys: nil)
//        self.didFinishMapping()
//    }
//}

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

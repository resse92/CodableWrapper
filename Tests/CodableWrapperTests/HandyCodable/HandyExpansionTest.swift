// CodableWrapper
// Created by: resse

//import CodableWrapper
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest



#if canImport(CodableWrapperMacros)
import CodableWrapperMacros

let testMacros: [String: Macro.Type] = [
    "HandyCodable": HandyCodable.self,
]
#endif

final class HandyCodableTest: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testHandyCodable() throws {
//#if canImport(CodableWrapperMacros)
//        assertMacroExpansion(
//#"""
//@HandyCodable
//struct HandyCodableModel {
//    var s: String = ""//abcd
//    var date: Date = Date()
//    var s2: String = ""
//    var s3: String = ""
//    var floa: float = 0.0
//    
//    mutating func mapping(mapper: HelpingMapper) {
//        mapper <<<
//            self.s <-- "s1"
//        mapper <<<
//            floa <-- ["float", "float1"]
//        mapper <<<
//            s3 <-- StringTransform()
//        mapper <<<
//            date <-- (["date", "date2"], DateTransform())
//        mapper <<<
//            s2 <-- ("s2", StringTransform())
//    }
//}
//"""#,
//expandedSource: #"""
//struct HandyCodableModel {
//    var s: String = ""
//    var date: Date = Date()
//    var s2: String = ""
//    var s3: String = ""
//    var floa: float = 0.0
//    
//    mutating func mapping(mapper: HelpingMapper) {
//        mapper <<<
//            s <-- "s1"
//        mapper <<<
//            floa <-- ["float", "float1"]
//        mapper <<<
//            s3 <-- StringTransform()
//        mapper <<<
//            date <-- (["date", "date2"], DateTransform())
//        mapper <<<
//            s2 <-- ("s2", StringTransform())
//    }
//}
//extension HandyCodableModel: _HandyCodable { }
//"""#,
//macros: testMacros
//        )
//#else
//        XCTAssert(false, "CodableWrapperMacros not available")
//#endif
//    }
}

// CodableWrapper
// Created by: resse

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import CodableWrapper

@HandyCodable
struct HandyNormalModel {
    var show: String?
    
    var actorName1: String? = nil
    
    var actorName2: String? = nil
    
    var iq: Int = 0
    
    var id: Int = 12
    
    init() { }
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            show <-- "title"
        mapper <<<
            actorName1 <-- "actor.actorName"
        mapper <<<
            actorName2 <-- "actor.actor_name"
        mapper <<<
            iq <-- "actor.iq"
    }
}


class HandyNormalTest: XCTestCase {
    let JSON = """
    {
        "title": "The Big Bang Theory",
        "actor": {
            "actor_name": "Sheldon Cooper",
            "iq": 140
        }
    }
    """

    func testNormalCodable() throws {
        let model = try JSONDecoder().decode(HandyNormalModel.self, from: JSON.data(using: .utf8)!)
        
        XCTAssertEqual(model.show, "The Big Bang Theory")
        XCTAssertEqual(model.actorName1, "Sheldon Cooper")
        XCTAssertEqual(model.actorName2, "Sheldon Cooper")
        XCTAssertEqual(model.iq, 140)
        XCTAssertEqual(model.id, 12)
        
        let jsonData = try JSONEncoder().encode(model)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
        let actor = (jsonObject["actor"] as? [String: Any])
        XCTAssertEqual(jsonObject["title"] as? String, "The Big Bang Theory")
        XCTAssertEqual(actor?["actorName"] as? String, "Sheldon Cooper")
        XCTAssertEqual(actor?["actor_name"] as? String, "Sheldon Cooper")
        XCTAssertEqual(actor?["iq"] as? Int, 140)
        XCTAssertEqual(jsonObject["id"] as? Int, 12)
        
    }
}

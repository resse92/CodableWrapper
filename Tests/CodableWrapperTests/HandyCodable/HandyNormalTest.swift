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
    var url: URL? = nil
    var decimal: NSDecimalNumber?
    var date: Date?
    
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
        mapper <<<
            url <-- (["_url", "url"], URLTransform())
        mapper <<<
            decimal <-- ("d", NSDecimalNumberTransform())
        mapper <<<
            date <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd HH:mm:ss")
    }
}


class HandyNormalTest: XCTestCase {
    let JSON = """
    {
        "title": "The Big Bang Theory",
        "actor": {
            "actor_name": "Sheldon Cooper",
            "iq": 140
        },
        "url": "https://www.baidu.com/",
        "d": 0.9819211,
        "date": "2024-08-01 14:00:00"
    }
    """

    func testNormalCodable() throws {
        let model = try JSONDecoder().decode(HandyNormalModel.self, from: JSON.data(using: .utf8)!)
        
        XCTAssertEqual(model.show, "The Big Bang Theory")
        XCTAssertEqual(model.actorName1, "Sheldon Cooper")
        XCTAssertEqual(model.actorName2, "Sheldon Cooper")
        XCTAssertEqual(model.iq, 140)
        XCTAssertEqual(model.id, 12)
        XCTAssertEqual(model.url, URL(string: "https://www.baidu.com/"))
        XCTAssertEqual(model.decimal, NSDecimalNumber(value: 0.9819211))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        XCTAssertEqual(model.date, formatter.date(from: "2024-08-01 14:00:00"))
        
        let jsonData = try JSONEncoder().encode(model)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
        print(jsonObject)
        let actor = (jsonObject["actor"] as? [String: Any])
        XCTAssertEqual(jsonObject["title"] as? String, "The Big Bang Theory")
        XCTAssertEqual(actor?["actorName"] as? String, "Sheldon Cooper")
        XCTAssertEqual(actor?["actor_name"] as? String, "Sheldon Cooper")
        XCTAssertEqual(actor?["iq"] as? Int, 140)
        XCTAssertEqual(jsonObject["id"] as? Int, 12)
        XCTAssertEqual(jsonObject["_url"] as? String, "https://www.baidu.com/")
        XCTAssertEqual(jsonObject["d"] as? Double, 0.9819210999999995)
    }
}

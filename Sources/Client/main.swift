// CodableWrapper
// Created by: resse

import Foundation
import CodableWrapper

//open class DateTransform: TransformType {
//    public typealias Object = Date
//    public typealias JSON = Double
//
//    public init() {}
//
//    public func transformFromJSON(_ json: JSON?) -> Date {
//        if let timeInt = json {
//            return Date(timeIntervalSince1970: TimeInterval(timeInt))
//        }
//
//        return Date()
//    }
//
//    public func transformToJSON(_ object: Date) -> Double? {
//        Double(object.timeIntervalSince1970)
//    }
//}
//
//
//@HandyCodable
//struct HandyCodableModel {
//    var s: String = ""
//    var date: Date = Date()
//    
//    mutating func mapping(mapper: HelpingMapper) {
//        mapper <<<
//            s <-- "s1"
//        mapper <<<
//            date <-- ("date", DateTransform())
//    }
//    
//    init() {
//        
//    }
//}
//
//let model = HandyCodableModel()
//print(model)

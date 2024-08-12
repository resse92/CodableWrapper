// CodableWrapper
// Created by: resse

import Foundation

open class DateTransform: TransformType {
    public typealias Object = Date?
    public typealias JSON = Double

    public init() {}

    open func transformFromJSON(_ value: JSON?) -> Object {
        if let value = value {
            return Date(timeIntervalSince1970: TimeInterval(value))
        }
        return nil
    }

    open func transformToJSON(_ value: Object) -> JSON? {
        guard let object = value else {
            return nil
        }
        return Double(object.timeIntervalSince1970)
    }
}

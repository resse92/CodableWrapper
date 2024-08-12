// CodableWrapper
// Created by: resse

import Foundation

open class DateFormatterTransform: TransformType {
    public typealias Object = Date?
    public typealias JSON = String

    public let dateFormatter: DateFormatter

    public init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }

    open func transformFromJSON(_ value: JSON?) -> Object {
        if let dateString = value {
            return dateFormatter.date(from: dateString)
        }
        return nil
    }

    open func transformToJSON(_ value: Object) -> JSON? {
        if let date = value {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

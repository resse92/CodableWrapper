// CodableWrapper
// Created by: resse

import Foundation

open class NSDecimalNumberTransform: TransformType {
    
    public typealias Object = NSDecimalNumber?
    public typealias JSON = Double

    public init() {}

    open func transformFromJSON(_ value: JSON?) -> NSDecimalNumber? {
        if let double = value {
            return NSDecimalNumber(value: double)
        }
        return 0
    }

    open func transformToJSON(_ value: Object) -> Double? {
        value?.doubleValue
    }
}

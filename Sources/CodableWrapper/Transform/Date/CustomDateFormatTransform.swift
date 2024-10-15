// CodableWrapper
// Created by: resse

import Foundation

open class _CustomDateFormatTransform: _DateFormatterTransform {

    public init(formatString: String) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = formatString

        super.init(dateFormatter: formatter)
    }
}

open class ISO8601DateTransform: _DateFormatterTransform {

    public init() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        super.init(dateFormatter: formatter)
    }

}

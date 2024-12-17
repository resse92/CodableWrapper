import Foundation

public extension KeyedDecodingContainer where K == AnyCodingKey {
    func decode<Value: Decodable>(type: Value.Type,
                                  keys: [String],
                                  nestedKeys: [String]) throws -> Value {
        for key in nestedKeys {
            if let value = try tryNestedKeyDecode(type: type, key: key) {
                return value
            }
        }
        for key in keys {
            if let value = try tryNormalKeyDecode(type: type, key: key) {
                return value
            }
        }
        // if Value is Optional，return nil
        if let valueType = Value.self as? ExpressibleByNilLiteral.Type {
            return valueType.init(nilLiteral: ()) as! Value
        }

        throw CodableWrapperError("decode failure: keys: \(keys), nestedKeys: \(nestedKeys)")
    }
}

private extension KeyedDecodingContainer where K == AnyCodingKey {
    func tryNormalKeyDecode<Value: Decodable>(type: Value.Type, key: String) throws -> Value? {
        func _decode(key: String) throws -> Value? {
            guard let key = Key(stringValue: key) else {
                return nil
            }
            if let value = try decodeIfPresent(type, forKey: key) {
                return value
            }
            let value = try? decodeIfPresent(AnyDecodable.self, forKey: key)?.value
            if let value = value {
                if let converted = value as? Value {
                    return converted
                }
                if let _bridged = (Value.self as? _BuiltInBridgeType.Type)?._transform(from: value), let __bridged = _bridged as? Value {
                    return __bridged
                }
                if let value = try? Value.decode(from: self, forKey: key) {
                    return value
                }
            }
            return nil
        }

        for newKey in [key, key.snakeCamelConvert()].compactMap({ $0 }) {
            if let value = try _decode(key: newKey) {
                return value
            }
        }
        return nil
    }

    private func tryNestedKeyDecode<Value: Decodable>(type: Value.Type, key: String) throws -> Value? {
        var keyComps = key.components(separatedBy: ".")
        guard let rootKey = AnyCodingKey(stringValue: keyComps.removeFirst()) else {
            return nil
        }
        var container: KeyedDecodingContainer<AnyCodingKey>?
        container = try? nestedContainer(keyedBy: AnyCodingKey.self, forKey: rootKey)
        let lastKey = keyComps.removeLast()
        for keyComp in keyComps {
            if let temp = try? container?.nestedContainer(keyedBy: AnyCodingKey.self, forKey: .init(stringValue: keyComp)!) {
                container = temp
            } else {
                container = nil
            }
        }
        if let container = container {
            if let value = try container.tryNormalKeyDecode(type: type, key: lastKey) {
                return value
            }
        }
        return nil
    }
}

private extension Decodable {
    static func decode<K>(from container: KeyedDecodingContainer<K>, forKey key: KeyedDecodingContainer<K>.Key) throws -> Self {
        return try container.decode(Self.self, forKey: key)
    }
}

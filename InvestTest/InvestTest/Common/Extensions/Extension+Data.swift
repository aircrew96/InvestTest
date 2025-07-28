
import Foundation

extension Data {

    public func hexed() -> String {
        map { String(format: "%02hhx", $0) }.joined()
    }

    func padded(to size: Int) -> Data {
        Data(count: Swift.max(size - count, 0)) + self
    }

    public init?(base64UrlEncoded: String, options: Data.Base64DecodingOptions = []) {
        self.init(base64Encoded: base64UrlEncoded.base64UrlUnescaped(), options: options)
    }

    public func base64UrlEncodedString(options: Data.Base64EncodingOptions = []) -> String {
        return base64EncodedString(options: options).base64UrlEscaped()
    }
}

func ^ (lhs: Data, rhs: Data) -> Data {
    precondition(lhs.count == rhs.count, "Data has to be the same size")
    var result = Data(count: lhs.count)
    for index in lhs.indices {
        result[index] = lhs[index] ^ rhs[index]
    }
    return result
}

fileprivate extension String {

    func base64UrlUnescaped() -> String {
        let replaced = self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let padding = replaced.count % 4
        return padding > 0 ? replaced + String(repeating: "=", count: 4 - padding) : replaced
    }

    func base64UrlEscaped() -> String {
        self
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

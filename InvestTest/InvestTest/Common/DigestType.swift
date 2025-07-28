
import Foundation
import CommonCrypto

protocol Digest {
    func compute(data: Data) -> Data
    func compute(bytes: [UInt8]) -> Data
}

struct SHA256: Digest {

    func compute(data: Data) -> Data {
        var digest = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return Data(digest)
    }

    public func compute(bytes: [UInt8]) -> Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        bytes.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(bytes.count), &digest)
        }
        return Data(digest)
    }
}

enum DigestType {
    case sha256

    var digest: Digest {
        switch self {
        case .sha256:
            return SHA256()
        }
    }
}

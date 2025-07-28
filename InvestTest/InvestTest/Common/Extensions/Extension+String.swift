
import Foundation

extension String {

    func hashed(_ type: DigestType) -> Data {
        type.digest.compute(bytes: [UInt8](utf8))
    }
}

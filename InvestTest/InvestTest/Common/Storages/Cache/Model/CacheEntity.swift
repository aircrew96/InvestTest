
import Foundation

class CacheEntity<T: Codable>: ExpirableCacheEntity, Codable {

    let object: T

    init(object: T, ttl: Date) {
        self.object = object
        super.init(ttl: ttl)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decode(T.self, forKey: .object)
        let ttl = try container.decode(Date.self, forKey: .ttl)
        super.init(ttl: ttl)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(object, forKey: .object)
        try container.encode(ttl, forKey: .ttl)
    }

    private enum CodingKeys: String, CodingKey {
        case object
        case ttl
    }
}

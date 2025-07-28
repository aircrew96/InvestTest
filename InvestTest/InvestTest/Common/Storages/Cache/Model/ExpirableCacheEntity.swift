
import Foundation

class ExpirableCacheEntity {

    let ttl: Date
    var isExpired: Bool {
        ttl.timeIntervalSinceNow <= 0
    }

    init(ttl: Date) {
        self.ttl = ttl
    }
}

extension ExpirableCacheEntity: NSDiscardableContent {

    func beginContentAccess() -> Bool { true }

    func endContentAccess() {}

    func discardContentIfPossible() {}

    func isContentDiscarded() -> Bool { false }
}

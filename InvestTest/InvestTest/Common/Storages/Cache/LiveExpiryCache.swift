
import Foundation

enum LiveExpiryCache {
    case never
    case seconds(TimeInterval)
    case minutes(TimeInterval)
    case days(TimeInterval)


    func ttl(referenceDate: Date = Date()) -> Date {
        switch self {
        case .never:
            return .distantFuture
        case .seconds(let seconds):
            return referenceDate.addingTimeInterval(seconds)
        case .minutes(let minutes):
            return referenceDate.addingTimeInterval(60 * minutes)
        case .days(let days):
            return referenceDate.addingTimeInterval(86400 * days)
        }
    }
}

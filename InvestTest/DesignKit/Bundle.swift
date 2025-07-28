
import Foundation

extension Bundle {
    private class Module { }

    static var module: Bundle {
        Bundle(for: Module.self)
    }
}

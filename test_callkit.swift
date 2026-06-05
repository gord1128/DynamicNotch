import Foundation
import CallKit

class CallManager: NSObject, CXCallObserverDelegate {
    let callObserver = CXCallObserver()

    override init() {
        super.init()
        callObserver.setDelegate(self, queue: nil)
        print("Call observer started. Current calls: \(callObserver.calls)")
    }

    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        print("Call changed: \(call.uuid)")
        print("  isOutgoing: \(call.isOutgoing)")
        print("  isOnHold: \(call.isOnHold)")
        print("  hasConnected: \(call.hasConnected)")
        print("  hasEnded: \(call.hasEnded)")
    }
}

let manager = CallManager()
RunLoop.main.run(until: Date(timeIntervalSinceNow: 5))

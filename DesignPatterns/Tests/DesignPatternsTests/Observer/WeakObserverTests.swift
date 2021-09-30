import XCTest
@testable import DesignPatterns

final class EventHandlerTests: XCTestCase {
    struct Source {
        var event = Event<Void>()

        func sendEvent() {
            event.send()
        }
    }

    class Handler {
        var isHandled = false
        func onEvent(_: Void) -> Void {
            isHandled = true
        }
    }

    func testEventWithoutParams() {
        let s = Source()
        let h = Handler()
        s.event += WeakObserver(target: h, action: Handler.onEvent)
        s.sendEvent()
        XCTAssertTrue(h.isHandled)
    }

    func testEventWithTwoObservers() {
        let s = Source()
        let h1 = Handler()
        let h2 = Handler()
        s.event += WeakObserver(target: h1, action: Handler.onEvent)
        s.event += WeakObserver(target: h2, action: Handler.onEvent)
        s.sendEvent()
        XCTAssertTrue(h1.isHandled && h2.isHandled)
    }

    func testEventWithDeadHandler() {
        let s = Source()
        var wh: Handler? = Handler()
        let h = Handler()
        s.event += WeakObserver(target: h, action: Handler.onEvent)
        s.event += WeakObserver(target: wh, action: Handler.onEvent)
        wh = nil
        s.sendEvent()
        XCTAssertTrue(h.isHandled)
    }
}

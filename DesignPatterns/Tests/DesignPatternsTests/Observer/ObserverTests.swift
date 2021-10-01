import XCTest
@testable import DesignPatterns

final class ObserverTests: XCTestCase {
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
        s.event += Observer(target: h, action: Handler.onEvent)
        s.sendEvent()
        XCTAssertTrue(h.isHandled)
    }

    func testEventWithTwoObservers() {
        let s = Source()
        let h1 = Handler()
        let h2 = Handler()
        s.event += Observer(target: h1, action: Handler.onEvent)
        s.event += Observer(target: h2, action: Handler.onEvent)
        s.sendEvent()
        XCTAssertTrue(h1.isHandled && h2.isHandled)
    }

    func testEventWithDeadHandler() {
        let s = Source()
        var wh: Handler? = Handler()
        let h1 = Handler()
        let h2 = Handler()
        s.event += Observer(target: h1, action: Handler.onEvent)
        s.event += Observer(target: wh, action: Handler.onEvent)
        s.event += Observer(target: h2, action: Handler.onEvent)
        s.sendEvent()
        XCTAssertTrue(h1.isHandled && h2.isHandled && (wh?.isHandled ?? false))
        h1.isHandled = false
        h2.isHandled = false
        wh = nil
        s.sendEvent()
        XCTAssertTrue(h1.isHandled && h2.isHandled)
    }

    func testEventWithLinkHandler() {
        let s = Source()
        let h1 = Handler()
        let h2 = Handler()
        let h3 = Handler()
        s.event += Observer(target: h1, action: Handler.onEvent)
        do {
            let link = Observer.Link(target: h2, action: Handler.onEvent)
            s.event += link
            s.sendEvent()
            XCTAssertTrue(h1.isHandled)
            XCTAssertTrue(h2.isHandled)
            h1.isHandled = false
            h2.isHandled = false
        }
        // link dead now
        s.event += Observer(target: h3, action: Handler.onEvent)
        s.sendEvent()

        XCTAssertTrue(h1.isHandled)
        XCTAssertFalse(h2.isHandled)
        XCTAssertTrue(h3.isHandled)
    }
}

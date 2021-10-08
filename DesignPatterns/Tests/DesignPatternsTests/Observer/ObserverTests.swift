import XCTest
@testable import DesignPatterns

private protocol Source {
    var eventVoid: Event<Void> { get }
    var eventInt: Event<Int> { get }
}

private final class Emitter {
    var voidSender = EventSender<Void>()
    var intSender = EventSender<Int>()

    func sendVoid() {
        voidSender.send()
    }

    func sendInt(_ value: Int) {
        intSender.send(value)
    }
}

extension Emitter: Source {
    var eventVoid: Event<Void> { self.voidSender }
    var eventInt: Event<Int> { self.intSender }
}

private final class Handler {
    var isHandledVoid = false
    var isHandledInt = false
    func onVoid(_: Void) {
        isHandledVoid = true
    }
    func onInt(_: Int) {
        isHandledInt = true
    }
}

final class ObserverTests: XCTestCase {
    func testEventWithoutParams() {
        let e = Emitter()
        let h = Handler()
        let s: Source = e
        s.eventVoid += Observer(target: h, action: Handler.onVoid)
        XCTAssertFalse(h.isHandledVoid)
        e.sendVoid()
        XCTAssertTrue(h.isHandledVoid)
    }

    func testEventWithOneParam() {
        let e = Emitter()
        let h = Handler()
        let s: Source = e
        s.eventInt += Observer(target: h, action: Handler.onInt)
        XCTAssertFalse(h.isHandledInt)
        e.sendInt(1)
        XCTAssertTrue(h.isHandledInt)
    }

    func testEventWithTwoObservers() {
        let e = Emitter()
        let s: Source = e
        let h1 = Handler()
        let h2 = Handler()
        s.eventVoid += Observer(target: h1, action: Handler.onVoid)
        s.eventVoid += Observer(target: h2, action: Handler.onVoid)
        e.sendVoid()
        XCTAssertTrue(h1.isHandledVoid && h2.isHandledVoid)
    }

    func testEventWithDeadHandler() {
        let e = Emitter()
        let s: Source = e
        var wh: Handler? = Handler()
        let h1 = Handler()
        let h2 = Handler()
        s.eventVoid += Observer(target: h1, action: Handler.onVoid)
        s.eventVoid += Observer(target: wh, action: Handler.onVoid)
        s.eventVoid += Observer(target: h2, action: Handler.onVoid)
        e.sendVoid()
        XCTAssertTrue(h1.isHandledVoid && h2.isHandledVoid && (wh?.isHandledVoid ?? false))
        h1.isHandledVoid = false
        h2.isHandledVoid = false
        wh = nil
        // three handlers now wh is dead
        e.sendVoid()
        // two handlers now
        XCTAssertTrue(h1.isHandledVoid && h2.isHandledVoid)
    }

    func testEventWithLinkHandler() {
        let e = Emitter()
        let s: Source = e
        let h1 = Handler()
        let h2 = Handler()
        let h3 = Handler()
        s.eventVoid += Observer(target: h1, action: Handler.onVoid)
        var mayBeLink: Any?
        do {
            let link = Observer.Link(target: h2, action: Handler.onVoid)
            s.eventVoid += link
            mayBeLink = link
        }
        e.sendVoid()
        XCTAssertTrue(h1.isHandledVoid)
        XCTAssertTrue(h2.isHandledVoid)
        h1.isHandledVoid = false
        h2.isHandledVoid = false
        XCTAssertNotNil(mayBeLink)
        mayBeLink = nil
        s.eventVoid += Observer(target: h3, action: Handler.onVoid)
        // link dead now but 3 handlers
        e.sendVoid()
        // two handlers now

        XCTAssertTrue(h1.isHandledVoid)
        XCTAssertFalse(h2.isHandledVoid)
        XCTAssertTrue(h3.isHandledVoid)
    }
}

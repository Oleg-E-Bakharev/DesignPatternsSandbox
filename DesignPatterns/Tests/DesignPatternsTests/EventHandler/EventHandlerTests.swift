import XCTest
@testable import DesignPatterns

final class EventHandlerTests: XCTestCase {
    func testEventWithoutParams() {
        struct Source {
            var event: EventHandler<Void>?

            func fireEvent() {
                event?.fire()
            }
        }

        class Handler {
            var exp: XCTestExpectation?
            func onFire(_: Void) -> Void {
                exp?.fulfill()
            }
        }

        var s = Source()
        let h = Handler()
        h.exp = expectation(description: "event handled")

        s.event = WeakHandler(target: h, action: Handler.onFire)

        s.fireEvent()

        waitForExpectations(timeout: 1)
    }

    func testEventWithOneParams() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(DesignPatterns().text, "Hello, World!")
    }
}

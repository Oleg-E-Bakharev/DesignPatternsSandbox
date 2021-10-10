# DesignPatterns

Common design patterns.

## Observer pattern
Allows to make one-to many weak relationships
````
protocol Subject {
    var eventVoid: Event<Void> { get }
}

class Emitter: Subject {
    var voidSender = EventSender<Void>()
    var eventVoid: Event<Void> { self.voidSender }
    
    func sendVoid() {
        voidSender.send()
    }
}

class Handler {
    var isHandledVoid = false
    func onVoid(_: Void) {
        isHandledVoid = true
    }
}

func test() {
    let e = Emitter()
    let h = Handler()
    let s: Subject = e
    s.eventVoid += Observer(target: h, action: Handler.onVoid)
    XCTAssertFalse(h.isHandledVoid)
    e.sendVoid()
    XCTAssertTrue(h.isHandledVoid)
}
````

//
//  Created by Oleg Bakharev on 10.10.2021.
//

///  Слушатель связи "один ко многим" на основе замыкания.
public final class ObserverClosure<Param> : EventHandler<Param> {
    public typealias Action = (Param)->Void
    let action: Action

    public init(action: @escaping Action) {
        self.action = action
    }

    public override func handle(_ param: Param) -> Bool {
        action(param)
        return true
    }
}

public extension Event {
    /// Использование: event += { value in }
    static func += (event: Event, action: @escaping (Param)->Void) {
        event += ObserverClosure(action: action)
    }
}

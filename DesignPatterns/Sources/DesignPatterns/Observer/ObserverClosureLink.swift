//
//  Created by Oleg Bakharev on 10.10.2021.
//

/// Посредник (Mediator) для создания обнуляемой связи к замыканию.
public extension ObserverClosure {
    final class Link {
        public typealias Action = (Param) -> Void
        let action: Action

        public init(action: @escaping Action) {
            self.action = action
        }

        func send(_ value: Param) -> Void {
            action(value)
        }
    }
}

public extension Event {
    /// Добавления обнуляемой связи к постоянному объекту. Если link удалится, то связь безопасно порвётся.
    static func += (event: Event, link: ObserverClosure<Param>.Link) {
        typealias Link = ObserverClosure<Param>.Link
        event += Observer(target: link, action: Link.send)
    }
}

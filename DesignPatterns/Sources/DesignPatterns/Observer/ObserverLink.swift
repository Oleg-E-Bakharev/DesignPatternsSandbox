//
//  Created by Oleg Bakharev on 01.10.2021.
//

/// Посредник (Mediator) для создания обнуляемой связи к постоянному объекту.
public extension Observer {
    final class Link {
        public typealias Action = (Target) -> (Param) -> Void
        weak var target: Target?
        let action: Action

        public init(target: Target, action: @escaping Action) {
            self.target = target
            self.action = action
        }

        func send(_ value: Param) -> Void {
            guard let target = target else { return }
            action(target)(value)
        }
    }
}

public extension Event {
    /// Добавления обнуляемой связи к постоянному объекту. Если link удалится, то связь безопасно порвётся.
    static func +=<Target> (event: Event, link: Observer<Target, Param>.Link) {
        typealias Link = Observer<Target, Param>.Link
        event += Observer(target: link, action: Link.send)
    }
}

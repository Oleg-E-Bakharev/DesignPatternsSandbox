//
//  Created by Oleg Bakharev on 29.09.2021.
//

/// Шаблон Наблюдатель события
/// Источник связи "один ко многим".
public class Event<Param> {
    typealias Handler = EventHandler<Param>

    /// Cписок обработчиков.
    private final class Node {
        var handler: Handler
        var next: Node?

        init(handler: Handler, next: Node?) {
            self.handler = handler
            self.next = next
        }
    }
    private var handlers: Node?

    /// Уведомить всех слушателей о возникновении события
    /// При этом все отвалившиеся слушатели удаляются из списка
    /// Недоступна для внешнего вызова. Для внешнего вызова использовать фасад EventSource.
    func notifyHandlers(_ value: Param) {
        handlers = step(handlers)

        func step(_ node: Node?) -> Node? {
            guard var current = node else { return nil }
            // Схлопываем пустые узлы
            while !current.handler.handle(value), let next = current.next {
                current = next
            }
            current.next = step(current.next)
            return current
        }
    }

    /// Добавление слушателя. Слушатель добавляется по слабой ссылке. Чтобы убрать слушателя, надо удалить его объект.
    /// Допустимо применять посредника (Observer.Link) для удаления слушателя без удаления целевого боъекта.
    public static func += (event: Event, handler: EventHandler<Param>) {
        event.handlers = Node(handler: handler, next: event.handlers)
    }
}

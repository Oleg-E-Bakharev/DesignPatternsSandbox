//
//  Created by Oleg Bakharev on 03.10.2021.
//

/// Фасад для использования EventSource.
/// Во внешний интерфейс выставляем Event. Внутри объявляем EventSource.
public final class EventSource<Param>: Event<Param> {
    /// Послать событие всем слушателям о возникновении события
    public func send(_ value: Param) {
        notifyHandlers(value)
    }

    public func send() where Param == Void {
        notifyHandlers(())
    }
}


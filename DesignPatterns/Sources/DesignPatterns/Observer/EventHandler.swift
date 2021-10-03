//
// Created by Oleg Bakharev on 29.09.2021.
//

public class EventHandler<Param> {
    /// Обработать полученное событие. Воззвращает статус true - слушатель готов волучать дальнейшие события. false - больше не послылать.
    public func handle(_ value: Param) -> Bool {
        fatalError("must override")
    }
}

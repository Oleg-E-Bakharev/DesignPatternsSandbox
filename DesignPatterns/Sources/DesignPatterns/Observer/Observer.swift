//
//  Created by Oleg Bakharev on 29.09.2021.
//

/// Шаблон Наблюдатель события
///  Слушатель связи "один ко многим".
public final class Observer<Target: AnyObject, Param> : EventHandler<Param> {
    weak var target: Target?

    public typealias Action = (Target)->(Param)->Void
    let action: Action

    public init(target: Target?, action: @escaping Action) {
        self.target = target
        self.action = action
    }

    public override func handle(_ param: Param) -> Bool {
        guard let target = target else { return false }
        action(target)(param)
        return true
    }
}

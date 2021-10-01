//
//  Created by Oleg Bakharev on 29.09.2021.
//

/// Шаблон Наблюдатель события
///  Слушатель связи "один ко многим".
public class Observer<Target: AnyObject, Param> : EventHandler<Param> {
    public private(set) weak var target: Target?

    public typealias Action = (Target)->(Param)->Void
    public let action: Action

    public init(target: Target?, action: @escaping Action) {
        self.target = target
        self.action = action
    }

    public override func send(_ param: Param) -> Bool {
        guard let target = target else { return false }
        action(target)(param)
        return true
    }
}

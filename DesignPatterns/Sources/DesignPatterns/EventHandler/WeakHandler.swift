//
//  File.swift
//  
//
//  Created by Oleg Bakharev on 29.09.2021.
//

/// Обработчик события
public class WeakHandler<Target: AnyObject, Param> : EventHandler<Param> {
    public private(set) weak var target: Target?

    public typealias Action = (Target)->(Param)->Void
    public let action: Action

    public init(target: Target, action: @escaping Action) {
        self.target = target
        self.action = action
    }

    public override func fire(_ param: Param) {
        if let target = target {
            action(target)(param)
        }
    }
}

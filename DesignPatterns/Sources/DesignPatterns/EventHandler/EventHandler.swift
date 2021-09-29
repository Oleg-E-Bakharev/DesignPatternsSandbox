//
//  Created by Oleg Bakharev on 29.09.2021.
//

public class EventHandler<Param> {
    public func fire(_ value: Param) {
        fatalError("must override")
    }

    public func fire() where Param == Void {
        fire(())
    }
}

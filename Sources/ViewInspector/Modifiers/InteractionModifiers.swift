import SwiftUI

// MARK: - InteractionEvents

public extension InspectableView {
    
    #if os(macOS)
    func callOnCutCommand() throws {
        let callback = try onCommandModifier(
            "cut:", type: (() -> Void).self, call: "onCutCommand")
        callback()
    }
    
    func callOnCopyCommand() throws {
        let callback = try onCommandModifier(
            "copy:", type: (() -> Void).self, call: "onCopyCommand")
        callback()
    }
    
    /* Not Supported
    func callOnPasteCommand() throws {
        typealias Callback = ([NSItemProvider]) -> (() -> Void)?
        let callback1 = try onCommandModifier(
            "paste:", path: "modifier|action|validatingDataHandler",
            type: Callback.self, call: "onPasteCommand")
        if let callback2 = callback1([]) {
            // Crashes here
            callback2()
        }
    }
    */
    
    func callOnDeleteCommand() throws {
        let callback = try onCommandModifier(
            "delete:", type: (() -> Void).self, call: "onDeleteCommand")
        callback()
    }
    #endif
    
    #if os(tvOS) || os(macOS)
    func callOnMoveCommand(_ direction: MoveCommandDirection = .up) throws {
        let callback = try onCommandModifier(
            direction.selector, type: (() -> Void).self, call: "onMoveCommand")
        callback()
    }
    
    func callOnExitCommand() throws {
        let callback = try onCommandModifier(
            "cancelOperation:", type: (() -> Void).self, call: "onExitCommand")
        callback()
    }
    #endif
    
    #if os(macOS)
    func callOnCommand(_ selector: Selector) throws {
        let callback = try onCommandModifier(
            String(describing: selector), type: (() -> Void).self, call: "onCommand")
        callback()
    }
    #endif
}

internal extension MoveCommandDirection {
    var selector: String {
        switch self {
        case .up: return "moveUp:"
        case .down: return "moveDown:"
        case .left: return "moveLeft:"
        case .right: return "moveRight:"
        default: return ""
        }
    }
}

internal extension InspectableView {
    func onCommandModifier<Type>(_ selector: String, path: String = "modifier|action|action",
                                 type: Type.Type, call: String) throws -> Type {
        return try modifierAttribute(modifierLookup: { modifier -> Bool in
            guard modifier.modifierType.contains("OnCommandModifier"),
                let command = try? Inspector.attribute(path: "modifier|command", value: modifier) as? Selector
                else { return false }
            return String(describing: command) == selector
        }, path: path, type: type, call: call)
    }
}

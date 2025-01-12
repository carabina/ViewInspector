import SwiftUI

public extension ViewType {
    
    struct AnyView: KnownViewType {
        public static var typePrefix: String = "AnyView"
    }
}

public extension AnyView {
    
    func inspect() throws -> InspectableView<ViewType.AnyView> {
        return try InspectableView<ViewType.AnyView>(self)
    }
}

// MARK: - Content Extraction

extension ViewType.AnyView: SingleViewContent {
    
    public static func content(view: Any, envObject: Any) throws -> Any {
        let view = try Inspector.attribute(path: "storage|view", value: view)
        return try Inspector.unwrap(view: view)
    }
}

// MARK: - Extraction from SingleViewContent parent

public extension InspectableView where View: SingleViewContent {
    
    func anyView() throws -> InspectableView<ViewType.AnyView> {
        let content = try View.content(view: view, envObject: envObject)
        return try InspectableView<ViewType.AnyView>(content)
    }
}

// MARK: - Extraction from MultipleViewContent parent

public extension InspectableView where View: MultipleViewContent {
    
    func anyView(_ index: Int) throws -> InspectableView<ViewType.AnyView> {
        let content = try contentView(at: index)
        return try InspectableView<ViewType.AnyView>(content)
    }
}

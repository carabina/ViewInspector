import SwiftUI

public extension ViewType {
    
    struct Image: KnownViewType {
        public static let typePrefix: String = "Image"
    }
}

public extension Image {
    
    func inspect() throws -> InspectableView<ViewType.Image> {
        return try InspectableView<ViewType.Image>(self)
    }
}

// MARK: - Extraction from SingleViewContent parent

public extension InspectableView where View: SingleViewContent {
    
    func image() throws -> InspectableView<ViewType.Image> {
        let content = try View.content(view: view, envObject: envObject)
        return try InspectableView<ViewType.Image>(content)
    }
}

// MARK: - Extraction from MultipleViewContent parent

public extension InspectableView where View: MultipleViewContent {
    
    func image(_ index: Int) throws -> InspectableView<ViewType.Image> {
        let content = try contentView(at: index)
        return try InspectableView<ViewType.Image>(content)
    }
}

// MARK: - Custom Attributes

public extension InspectableView where View == ViewType.Image {
    
    func imageName() throws -> String? {
        return try Inspector.attribute(label: "name", value: image()) as? String
    }
    
    #if os(iOS) || os(watchOS) || os(tvOS)
    func uiImage() throws -> UIImage? {
        return try image() as? UIImage
    }
    #else
    func nsImage() throws -> NSImage? {
        return try image() as? NSImage
    }
    #endif
    
    private func image() throws -> Any {
        return try Inspector.attribute(path: "provider|base", value: unwrap(view: view))
    }
    
    private func unwrap(view: Any) -> Any {
        if let enclosed = try? Inspector.attribute(path: "provider|base|base", value: view) {
            return unwrap(view: enclosed)
        }
        return view
    }
}

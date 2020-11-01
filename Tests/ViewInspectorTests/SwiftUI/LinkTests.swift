import XCTest
import SwiftUI
@testable import ViewInspector

#if !os(macOS) && !targetEnvironment(macCatalyst)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
final class LinkTests: XCTestCase {
    
    let url = URL(fileURLWithPath: "test")
    
    func testExtractionFromSingleViewContainer() throws {
        guard #available(iOS 14, macOS 11.0, tvOS 14.0, *) else { return }
        let view = AnyView(Link("abc", destination: url))
        XCTAssertNoThrow(try view.inspect().anyView().link())
    }
    
    func testExtractionFromMultipleViewContainer() throws {
        guard #available(iOS 14, macOS 11.0, tvOS 14.0, *) else { return }
        let view = HStack {
            Text("")
            Link("abc", destination: url)
            Text("")
        }
        XCTAssertNoThrow(try view.inspect().hStack().link(1))
    }
    
    func testURLInspection() throws {
        guard #available(iOS 14, macOS 11.0, tvOS 14.0, *) else { return }
        let view = Link("abc", destination: url)
        XCTAssertEqual(try view.inspect().link().url(), url)
    }
    
    func testLabelInspection() throws {
        guard #available(iOS 14, macOS 11.0, tvOS 14.0, *) else { return }
        let view = Link(destination: url, label: {
            HStack { Text("xyz") }
        })
        let sut = try view.inspect().link().labelView().hStack().text(0).string()
        XCTAssertEqual(sut, "xyz")
    }
}
#endif

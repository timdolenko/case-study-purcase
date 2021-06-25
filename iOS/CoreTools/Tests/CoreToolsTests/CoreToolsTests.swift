import XCTest
@testable import CoreTools

final class CoreToolsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CoreTools().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

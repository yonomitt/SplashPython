import XCTest
import Splash
@testable import SplashPython

class ConstantTests: XCTestCase {
    private(set) var highlighter: SyntaxHighlighter<OutputFormatMock>!
    private(set) var builder: OutputBuilderMock!
    
    override func setUp() {
        super.setUp()
        builder = OutputBuilderMock()
        
        let format = OutputFormatMock(builder: builder)
        highlighter = SyntaxHighlighter(format: format, grammar: PythonGrammar())
    }
    
    func testAllCaps() {
        let components = highlighter.highlight("SIZE = 24")
        XCTAssertEqual(components, [
            .token("SIZE", .custom("constant")),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("24", .number)
        ])
    }
        
    func testAllCapsWithUnderscore() {
        let components = highlighter.highlight("SIZE_W = 24")
        XCTAssertEqual(components, [
            .token("SIZE_W", .custom("constant")),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("24", .number)
        ])
    }
    
    func testAllCapsWithInteger() {
        let components = highlighter.highlight("SIZE0 = 24")
        XCTAssertEqual(components, [
            .token("SIZE0", .custom("constant")),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("24", .number)
        ])
    }

    func testAllCapsWithIntegerAndUnderscore() {
        let components = highlighter.highlight("SIZE_23 = 24")
        XCTAssertEqual(components, [
            .token("SIZE_23", .custom("constant")),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("24", .number)
        ])
    }
}

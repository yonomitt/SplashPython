import XCTest
import Splash
@testable import SplashPython

class NumberTests: XCTestCase {
    private(set) var highlighter: SyntaxHighlighter<OutputFormatMock>!
    private(set) var builder: OutputBuilderMock!
    
    override func setUp() {
        super.setUp()
        builder = OutputBuilderMock()
        
        let format = OutputFormatMock(builder: builder)
        highlighter = SyntaxHighlighter(format: format, grammar: PythonGrammar())
    }
    
    func testInteger() {
        let components = highlighter.highlight("x = 23")
        XCTAssertEqual(components, [
            .plainText("x"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("23", .number),
        ])
    }
    
    func testNegativeInteger() {
        let components = highlighter.highlight("x = -23")
        XCTAssertEqual(components, [
            .plainText("x"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .plainText("-"),
            .token("23", .number),
        ])
    }
    
    func testFloat() {
        let components = highlighter.highlight("x = 0.23")
        XCTAssertEqual(components, [
            .plainText("x"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("0.23", .number),
        ])
    }
    
    func testFloatNoNumberAfterDecimal() {
        let components = highlighter.highlight("x = 2.")
        XCTAssertEqual(components, [
            .plainText("x"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("2.", .number),
        ])

    }
    
    func testNegativeFloat() {
        let components = highlighter.highlight("x = -0.23")
        XCTAssertEqual(components, [
            .plainText("x"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .plainText("-"),
            .token("0.23", .number),
        ])
    }
    
    func testNegativeFloatNoNumberAfterDecimal() {
        let components = highlighter.highlight("x = -2.")
        XCTAssertEqual(components, [
            .plainText("x"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .plainText("-"),
            .token("2.", .number),
        ])

    }
}

import XCTest
import Splash
@testable import SplashPython

class StringTests: XCTestCase {
    private(set) var highlighter: SyntaxHighlighter<OutputFormatMock>!
    private(set) var builder: OutputBuilderMock!
    
    override func setUp() {
        super.setUp()
        builder = OutputBuilderMock()
        
        let format = OutputFormatMock(builder: builder)
        highlighter = SyntaxHighlighter(format: format, grammar: PythonGrammar())
    }
    
    func testSingleLineDoubleQuoteString() {
        let components = highlighter.highlight("print(\"This is a string\")")
        XCTAssertEqual(components, [
            .plainText("print("),
            .token("\"This", .string),
            .whitespace(" "),
            .token("is", .string),
            .whitespace(" "),
            .token("a", .string),
            .whitespace(" "),
            .token("string\"", .string),
            .plainText(")")
        ])
    }
    
    func testSingleLineSingleQuoteString() {
        let components = highlighter.highlight("print('This is a string')")
        XCTAssertEqual(components, [
            .plainText("print("),
            .token("'This", .string),
            .whitespace(" "),
            .token("is", .string),
            .whitespace(" "),
            .token("a", .string),
            .whitespace(" "),
            .token("string'", .string),
            .plainText(")")
        ])
    }
}

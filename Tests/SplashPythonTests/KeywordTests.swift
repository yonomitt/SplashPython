import XCTest
import Splash
@testable import SplashPython

class KeywordTests: XCTestCase {
    private(set) var highlighter: SyntaxHighlighter<OutputFormatMock>!
    private(set) var builder: OutputBuilderMock!
    
    override func setUp() {
        super.setUp()
        builder = OutputBuilderMock()
        
        let format = OutputFormatMock(builder: builder)
        highlighter = SyntaxHighlighter(format: format, grammar: PythonGrammar())
    }
    
    func testBooleanKeywords() {
        let components = highlighter.highlight("print('Hi ' + str(True or False and 0)")
        XCTAssertEqual(components, [
            .token("print", .custom("builtin")),
            .plainText("("),
            .token("'Hi", .string),
            .whitespace(" "),
            .token("'", .string),
            .whitespace(" "),
            .plainText("+"),
            .whitespace(" "),
            .token("str", .custom("builtin")),
            .plainText("("),
            .token("True", .keyword),
            .whitespace(" "),
            .token("or", .keyword),
            .whitespace(" "),
            .token("False", .keyword),
            .whitespace(" "),
            .token("and", .keyword),
            .whitespace(" "),
            .token("0", .number),
            .plainText(")")
        ])
    }
}

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
            .token("print", .custom("builtin")),
            .plainText("("),
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
            .token("print", .custom("builtin")),
            .plainText("("),
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
    
    func testFormatDoubleQuoteString() {
        let components = highlighter.highlight("mlmodel.save(f\"AnimeGANv2_{SIZE}.mlmodel\")")
        XCTAssertEqual(components, [
            .plainText("mlmodel.save(f"),
            .token("\"AnimeGANv2_", .string),
            .plainText("{SIZE}"),
            .token(".mlmodel\"", .string),
            .plainText(")")
        ])
    }
}

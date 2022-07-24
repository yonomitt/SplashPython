import XCTest
import Splash
@testable import SplashPython

class BuiltinTests: XCTestCase {
    private(set) var highlighter: SyntaxHighlighter<OutputFormatMock>!
    private(set) var builder: OutputBuilderMock!
    
    override func setUp() {
        super.setUp()
        builder = OutputBuilderMock()
        
        let format = OutputFormatMock(builder: builder)
        highlighter = SyntaxHighlighter(format: format, grammar: PythonGrammar())
    }
    
    func testRealBuiltin() {
        let components = highlighter.highlight("x = input('>>> ')")
        XCTAssertEqual(components, [
            .plainText("x"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("input", .custom("builtin")),
            .plainText("("),
            .token("'>>>", .string),
            .whitespace(" "),
            .token("'", .string),
            .plainText(")")
        ])
    }
    
    func testFakeBuiltin() {
        let components = highlighter.highlight("input = len(x)")
        XCTAssertEqual(components, [
            .plainText("input"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("len", .custom("builtin")),
            .plainText("(x)")
        ])
    }
}

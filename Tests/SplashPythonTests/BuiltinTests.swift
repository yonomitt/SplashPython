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
    
    func testMultipleBuiltIns() {
        let components = highlighter.highlight("list(zip(list1, list2))[2:7]")
        XCTAssertEqual(components, [
            .token("list", .custom("builtin")),
            .plainText("("),
            .token("zip", .custom("builtin")),
            .plainText("(list1,"),
            .whitespace(" "),
            .plainText("list2))["),
            .token("2", .number),
            .plainText(":"),
            .token("7", .number),
            .plainText("]")
        ])
    }
}

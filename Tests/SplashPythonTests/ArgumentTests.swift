import XCTest
import Splash
@testable import SplashPython

class ArgumentTests: XCTestCase {
    private(set) var highlighter: SyntaxHighlighter<OutputFormatMock>!
    private(set) var builder: OutputBuilderMock!
    
    override func setUp() {
        super.setUp()
        builder = OutputBuilderMock()
        
        let format = OutputFormatMock(builder: builder)
        highlighter = SyntaxHighlighter(format: format, grammar: PythonGrammar())
    }
    
    func testArgumentsNoSpace() {
        let components = highlighter.highlight("input = ct.TensorType(name=\"input\", shape=dummy_in.shape)")
        XCTAssertEqual(components, [
            .plainText("input"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .plainText("ct."),
            .token("TensorType", .type),
            .plainText("("),
            .token("name", .custom("argument")),
            .plainText("="),
            .token("\"input\"", .string),
            .plainText(","),
            .whitespace(" "),
            .token("shape", .custom("argument")),
            .plainText("=dummy_in.shape)")
        ])
    }
    
    func testArgumentsWithSpaces() {
        let components = highlighter.highlight("def main(args = None, count = 2):")
        XCTAssertEqual(components, [
            .token("def", .keyword),
            .whitespace(" "),
            .token("main", .call),
            .plainText("("),
            .token("args", .custom("argument")),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("None", .keyword),
            .plainText(","),
            .whitespace(" "),
            .token("count", .custom("argument")),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("2", .number),
            .plainText("):")
        ])
    }
}

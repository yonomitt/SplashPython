import XCTest
import Splash
@testable import SplashPython

class CommentTests: XCTestCase {
    private(set) var highlighter: SyntaxHighlighter<OutputFormatMock>!
    private(set) var builder: OutputBuilderMock!

    override func setUp() {
        super.setUp()
        builder = OutputBuilderMock()

        let format = OutputFormatMock(builder: builder)
        highlighter = SyntaxHighlighter(format: format, grammar: PythonGrammar())
    }
    
    func testBeginLineComment() {
        let components = highlighter.highlight("#n = 24")
        XCTAssertEqual(components, [
            .token("#n", .comment),
            .whitespace(" "),
            .token("=", .comment),
            .whitespace(" "),
            .token("24", .comment)
        ])
    }
    
    func testMiddleLineComment() {
        let components = highlighter.highlight("n = 42 # This is a cool comment")
        XCTAssertEqual(components, [
            .plainText("n"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .plainText("42"),
            .whitespace(" "),
            .token("#", .comment),
            .whitespace(" "),
            .token("This", .comment),
            .whitespace(" "),
            .token("is", .comment),
            .whitespace(" "),
            .token("a", .comment),
            .whitespace(" "),
            .token("cool", .comment),
            .whitespace(" "),
            .token("comment", .comment),
        ])
    }
}

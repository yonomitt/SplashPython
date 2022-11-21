import XCTest
import Splash
@testable import SplashPython

class CallTests: XCTestCase {
    private(set) var highlighter: SyntaxHighlighter<OutputFormatMock>!
    private(set) var builder: OutputBuilderMock!
    
    override func setUp() {
        super.setUp()
        builder = OutputBuilderMock()
        
        let format = OutputFormatMock(builder: builder)
        highlighter = SyntaxHighlighter(format: format, grammar: PythonGrammar())
    }
    
    func testFunctionCallWithIntegers() {
        let components = highlighter.highlight("add(1, 2)")
        
        XCTAssertEqual(components, [
            .token("add", .call),
            .plainText("("),
            .token("1", .number),
            .plainText(","),
            .whitespace(" "),
            .token("2", .number),
            .plainText(")")
        ])
    }
    
    func testAccessingSliceAfterFunctionCallWithoutArguments() {
        let components = highlighter.highlight("some_tensor.tolist()[2:7]")

        XCTAssertEqual(components, [
            .plainText("some_tensor."),
            .token("tolist", .call),
            .plainText("()["),
            .token("2", .number),
            .plainText(":"),
            .token("7", .number),
            .plainText("]")
        ])
    }
}

import XCTest
import Splash
@testable import SplashPython

class TypeTests: XCTestCase {
    private(set) var highlighter: SyntaxHighlighter<OutputFormatMock>!
    private(set) var builder: OutputBuilderMock!
    
    override func setUp() {
        super.setUp()
        builder = OutputBuilderMock()
        
        let format = OutputFormatMock(builder: builder)
        highlighter = SyntaxHighlighter(format: format, grammar: PythonGrammar())
    }
    
    func testTypeCallFromModule() {
        let components = highlighter.highlight("tensor = ct.TensorType(name=\"input\", shape=dummy_in.shape)")
        XCTAssertEqual(components, [
            .plainText("tensor"),
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
    
    func testTypeCallInClassDefinition() {
        let components = highlighter.highlight("class StableDiffusionWrapper(mlflow.pyfunc.PythonModel):")
        XCTAssertEqual(components, [
            .token("class", .keyword),
            .whitespace(" "),
            .token("StableDiffusionWrapper", .type),
            .plainText("(mlflow.pyfunc."),
            .token("PythonModel", .type),
            .plainText("):")
        ])
    }
}

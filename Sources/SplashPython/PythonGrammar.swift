import Foundation
import Splash

public struct PythonGrammar: Grammar {
    public var delimiters: CharacterSet
    public var syntaxRules: [SyntaxRule]
    
    public init() {
        var delimiters = CharacterSet.alphanumerics.inverted
        delimiters.remove("_")
        delimiters.remove("@")
        delimiters.remove("%")
        self.delimiters = delimiters
        
        syntaxRules = [
            CommentRule(),
            StringRule(),
            KeywordRule(),
            BuiltinRule(),
            NumberRule(),
            ConstantRule(),
            TypeRule(),
            CallRule(),
            ArgumentRule()
        ]
    }
    
    public func isDelimiter(_ delimiterA: Character,
                            mergableWith delimiterB: Character) -> Bool {
        switch (delimiterA, delimiterB) {
        case ("(", _), (_, ")"):
            return false
        case ("\"", _), ("'", _), (_, "\""), (_, "'"):
            return false
        case ("{", _), (_, "{"), (_, "}"), ("}", _):
            return false
        default:
            return true
        }
    }
    
    static let keywords: Set<String> = [
        "and", "as", "assert", "break",
        "class", "continue", "def", "del",
        "elif", "else", "except", "False",
        "finally", "for", "from", "global",
        "if", "import", "in", "is",
        "lambda", "None", "nonlocal", "not",
        "or", "pass", "raise", "return",
        "True", "try", "while", "with",
        "yield"
    ]
    
    static let builtins: Set<String> = [
        "abs", "aiter", "all", "any",
        "anext", "ascii",
        
        "bin", "bool", "breakpoint", "bytearray",
        "bytes",
        
        "callable", "chr", "classmethod", "compile",
        "complex",
        
        "delattr", "dict", "dir", "divmod",
        
        "enumerate", "eval", "exec",
        
        "filter", "float", "format", "frozenset",
        
        "getattr", "globals",
        
        "hasattr", "hash", "help", "hex",
        
        "id", "input", "int", "isinstance",
        "issubclass", "iter",
        
        "len", "list", "locals",
        
        "map", "max", "memoryview", "min",
        
        "next",
        
        "object", "oct", "open", "ord",
        
        "pow", "print", "property",
        
        "range", "repr", "reversed", "round",
        
        "set", "setattr", "slice", "sorted",
        "staticmethod", "str", "sum", "super",
        
        "tuple", "type",
        
        "vars",
        
        "zip",
        
        "__import__"
    ]
    
    struct CommentRule: SyntaxRule {
        var tokenType: TokenType { return .comment }
        
        func matches(_ segment: Splash.Segment) -> Bool {
            if segment.tokens.current.hasPrefix("#") {
                return true
            }
            
            if segment.tokens.onSameLine.contains("#") {
                return true
            }
            
            return false
        }
    }
    
    struct StringRule: SyntaxRule {
        var tokenType: TokenType { return .string }
        
        func matches(_ segment: Segment) -> Bool {
            if segment.tokens.current.hasPrefix("\"") &&
                segment.tokens.current.hasSuffix("\"") {
                return true
            }
            
            if segment.tokens.current.hasPrefix("'") &&
                segment.tokens.current.hasSuffix("'") {
                return true
            }
            
            let withinString =  segment.isWithinStringLiteral(withStart: "\"", end: "\"") ||
                segment.isWithinStringLiteral(withStart: "'", end: "'")
            let withinBraces = segment.isWithinStringLiteral(withStart: "{", end: "}")
            
            return withinString && !withinBraces
        }
    }
    
    struct KeywordRule: SyntaxRule {
        var tokenType: TokenType { return .keyword }
        
        func matches(_ segment: Segment) -> Bool {
            return keywords.contains(segment.tokens.current)
        }
    }
    
    struct BuiltinRule: SyntaxRule {
        var tokenType: TokenType { return .custom("builtin") }

        func matches(_ segment: Segment) -> Bool {
            return builtins.contains(segment.tokens.current) && (segment.tokens.next?.hasPrefix("(") ?? true) &&
                !(segment.tokens.previous?.hasSuffix(".") ?? false)
        }
    }
    
    struct NumberRule: SyntaxRule {
        var tokenType: TokenType { return .number }

        func matches(_ segment: Segment) -> Bool {
            if segment.tokens.current.isNumber {
                return true
            }

            // Double and floating point values that contain a "."
            guard segment.tokens.current == "." else {
                return false
            }

            guard let previous = segment.tokens.previous else {
                    return false
            }

            return previous.isNumber
        }
    }
    
    struct ConstantRule: SyntaxRule {
        var tokenType: TokenType { return .custom("constant") }
        
        func matches(_ segment: Segment) -> Bool {
            var allowedChars = CharacterSet.uppercaseLetters
            allowedChars = allowedChars.union(CharacterSet.decimalDigits)
            allowedChars.insert("_")
            
            let current = CharacterSet(charactersIn: segment.tokens.current)
            
            return allowedChars.isSuperset(of: current)
        }
    }
    
    struct TypeRule: SyntaxRule {
        var tokenType: TokenType { return .type }
        
        func matches(_ segment: Segment) -> Bool {
            // FIXME: add support for builtin types? (int, float, bytes, etc...)
            return segment.tokens.current.isCapitalized
        }
    }
    
    struct CallRule: SyntaxRule {
        var tokenType: TokenType { return .call }
        
        func matches(_ segment: Segment) -> Bool {
            if let previousToken = segment.tokens.previous,
                previousToken == "class" {
                return false
            }
            return segment.tokens.next?.starts(with: "(") ?? false
        }
    }
    
    struct ArgumentRule: SyntaxRule {
        var tokenType: TokenType { return .custom("argument") }
        
        func matches(_ segment: Segment) -> Bool {
            let countOpen = segment.tokens.count(of: "(")
            let countClose = segment.tokens.count(of: ")")
            let withinParens = countOpen == (countClose + 1)
            let precedesEqual = segment.tokens.next?.starts(with: "=") ?? false
            return withinParens && precedesEqual
        }
    }
}

extension Segment {
    func isWithinStringLiteral(withStart start: String, end: String) -> Bool {
        if tokens.current.hasPrefix(start) {
            return true
        }
        
        if tokens.current.hasSuffix(end) {
            return true
        }
        
        var markerCounts = (start: 0, end: 0)
        
        for token in tokens.onSameLine {
            if token == start {
                if start != end || markerCounts.start == markerCounts.end {
                    markerCounts.start += 1
                } else {
                    markerCounts.end += 1
                }
            } else if token == end && start != end {
                markerCounts.end += 1
            } else {
                if token.hasPrefix(start) {
                    markerCounts.start += 1
                }
                
                if token.hasSuffix(end) {
                    markerCounts.end += 1
                }
            }
        }
        
        return markerCounts.start != markerCounts.end
    }
}

import Foundation
import Splash

public struct PythonGrammar: Grammar {
    public var delimiters: CharacterSet
    public var syntaxRules: [SyntaxRule]
    
    public init() {
        var delimiters = CharacterSet.alphanumerics.inverted
        delimiters.remove("_")
        delimiters.remove("\"")
        delimiters.remove("'")
        delimiters.remove("@")
        delimiters.remove("%")
        self.delimiters = delimiters
        
        syntaxRules = [
            CommentRule(),
            StringRule()
        ]
    }
    
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
            
            return segment.isWithinStringLiteral(withStart: "\"", end: "\"") ||
                segment.isWithinStringLiteral(withStart: "'", end: "'")
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

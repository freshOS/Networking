//
//  ParsingError.swift
//
//

import Foundation


public enum ParsingError: Error, LocalizedError {
    
    case unknown, parsingError(error: Error)
    
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown parsing error"
        case .parsingError(let error):
            if let theError = error as? DecodingError {
                switch theError {
                case .typeMismatch(let key, let value):
                    return "error at \(key), value \(value) and ERROR: \(theError.localizedDescription)"
                case .valueNotFound(let key, let value):
                    return "error at \(key), value \(value) and ERROR: \(theError.localizedDescription)"
                case .keyNotFound(let key, let value):
                    return "error at \(key), value \(value) and ERROR: \(theError.localizedDescription)"
                case .dataCorrupted(let key):
                    return "error at \(key) and ERROR: \(theError.localizedDescription)"
                default:
                    return "error: \(theError.localizedDescription)"
                }
            } else {
                return "\(error.localizedDescription)"
            }
        }
    }
  
}

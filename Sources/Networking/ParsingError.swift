//
//  ParsingError.swift
//
//

import Foundation


public enum ParsingError: Error, LocalizedError {
    
    case unknown, withError(_ error: Error)
    
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown parsing error"
        case .withError(let error):
            if let theError = error as? DecodingError {
                switch theError {
                case .typeMismatch(_ , let value), .valueNotFound(_ , let value):
                    return "error: \(value.debugDescription)  \(theError.localizedDescription)"
                case .keyNotFound(_ , let value):
                    return "error: \(value.debugDescription)  \(theError.localizedDescription)"
                case .dataCorrupted(let key):
                    return "error at: \(key)  \(theError.localizedDescription)"
                default:
                    return "error: \(theError.localizedDescription)"
                }
            } else {
                return "\(error.localizedDescription)"
            }
        }
    }
  
}

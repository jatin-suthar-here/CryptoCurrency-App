//
//  optionalToString.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 22/04/23.
//

import Foundation

// converts optional data type into string data type
func optionalToString(val : Any) -> String
{
    switch val
    {
        case let val as Double:
            return String(val)
        case let val as Int:
            return String(val)
        case let val as String:
            return String(val)
        default:
            return ""
    }
}

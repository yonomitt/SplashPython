//
//  StringExtension.swift
//  
//
//  Created by Yonatan Mittlefehldt on 2022-07-31.
//

import Foundation

public extension String {
    var isNumber: Bool {
        return Int(self) != nil
    }
}

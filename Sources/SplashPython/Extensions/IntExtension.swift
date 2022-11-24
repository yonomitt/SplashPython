//
//  IntExtension.swift
//  
//
//  Created by Yonatan Mittlefehldt on 2022-11-23.
//

import Foundation

internal extension Int {
    var isEven: Bool {
        self % 2 == 0
    }
    
    var isOdd: Bool {
        !isEven
    }
}

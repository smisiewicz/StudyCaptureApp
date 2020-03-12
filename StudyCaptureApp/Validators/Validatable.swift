//
//  Validatable.swift
//  StudyCaptureApp
//
//  Created by Bastek on 3/11/20.
//  Copyright © 2020 Bastek. All rights reserved.
//

import Foundation


// Generic validation protocol for any additional types we might use in
// the future (e.g. direct textField validation, custom views, etc.)
// Just nicer to 'guide' the sigs:

enum ValidationResult<T> {
    case valid(T)
    case invalid(String)
}


protocol Validatable {
    associatedtype T
    func validate(input: T?) -> ValidationResult<T>
}

//
//  SubjectIdValidator.swift
//  StudyCaptureApp
//
//  Created by Bastek on 3/11/20.
//  Copyright © 2020 Bastek. All rights reserved.
//

import Foundation


struct SubjectIdValidator: Validatable {

    // simple RegEx validation to make sure we are alphanumeric with
    // minimum number of characters, etc.

    let MIN_CHAR_COUNT = 5

    typealias T = String

    func validate(input: String?) -> ValidationResult<String> {
        guard let input = input else {
            return .invalid("Subject ID is empty.")
        }

        if let _ = input.range(of: "^[a-zA-Z0-9]{\(MIN_CHAR_COUNT),}$", options: [.regularExpression]) {
            return .valid(input)
        }

        return .invalid("Subject ID must be alphanumeric with minimum \(MIN_CHAR_COUNT) characters.")
    }
}

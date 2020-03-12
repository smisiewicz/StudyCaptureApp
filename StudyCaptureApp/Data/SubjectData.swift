//
//  SubjectData.swift
//  StudyCaptureApp
//
//  Created by Bastek on 3/12/20.
//  Copyright © 2020 Bastek. All rights reserved.
//

import UIKit


struct SubjectData {
    private(set) var subjectId: String
    private(set) var subjectImage: UIImage

    init(subjectId: String, subjectImage: UIImage) {
        self.subjectId = subjectId
        self.subjectImage = subjectImage
    }
}

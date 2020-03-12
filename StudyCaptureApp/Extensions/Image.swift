//
//  Image.swift
//  StudyCaptureApp
//
//  Created by Bastek on 3/11/20.
//  Copyright © 2020 Bastek. All rights reserved.
//

import UIKit
import CoreImage


extension UIImage {
    func unsharpMaskImage(radius: Any, intensity: Any) -> UIImage {
        if let image = self.cgImage, let filter = CIFilter(name: "CIUnsharpMask") {
            filter.setValue(CIImage(cgImage: image), forKey: kCIInputImageKey)
            filter.setValue(radius, forKey: kCIInputRadiusKey)
            filter.setValue(intensity, forKey: kCIInputIntensityKey)

            if let outputImage = filter.outputImage {
                return UIImage(ciImage: outputImage)
            }
        }

        return self
    }


    func labeledImage(text: String) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)

        let attributes :[NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Helvetica Bold", size: 17)!,
            .foregroundColor: UIColor.white,
            .backgroundColor: UIColor.black
        ]

        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))

        let size = (text as NSString).size(withAttributes: attributes)
        let rect = CGRect(x: self.size.width - size.width,
                          y: self.size.height - size.height,
                          width: size.width,
                          height: size.height)
        text.draw(in: rect, withAttributes: attributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? self
    }
}

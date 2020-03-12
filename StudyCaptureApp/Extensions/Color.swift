//
//  Color.swift
//  StudyCaptureApp
//
//  Created by Bastek on 3/11/20.
//  Copyright © 2020 Bastek. All rights reserved.
//

import UIKit


extension UIColor {
    convenience init(hex: Int) {
        self.init(r:(hex >> 16) & 0xff,
                  g:(hex >> 8) & 0xff,
                  b:hex & 0xff)
    }

    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        assert(a >= 0.0 && a <= 1.0, "Invalid alpha component")

        self.init(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: a
        )
    }


    func with(alpha: CGFloat) -> UIColor {
        // bounds check
        var newAlpha = alpha
        if newAlpha < 0.0 { newAlpha = 0.0 }
        else if newAlpha > 1.0 { newAlpha = 1.0 }

        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: r,
                           green: g,
                           blue: b,
                           alpha: newAlpha)
        }

        return UIColor(r: 0,
                       g: 0,
                       b: 0,
                       a: newAlpha)
    }
}

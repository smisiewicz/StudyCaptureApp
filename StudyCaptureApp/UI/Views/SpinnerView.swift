//
//  SpinnerView.swift
//  StudyCaptureApp
//
//  Created by Bastek on 3/11/20.
//  Copyright © 2020 Bastek. All rights reserved.
//

import UIKit


@IBDesignable
class SpinnerView: UIView {

    //MARK: - Animation Path Setup
    struct Pose {
        let start: CGFloat
        let length: CGFloat

        init(_ start: CGFloat, _ length: CGFloat) {
            self.start = start
            self.length = length
        }
    }

    var poses: [Pose] {
        get {
            return [
                Pose(0.000, 0.7),
                Pose(0.500, 0.5),
                Pose(1.000, 0.3),
                Pose(1.500, 0.1),
                Pose(1.875, 0.1),
                Pose(2.250, 0.3),
                Pose(2.625, 0.5),
                Pose(3.000, 0.7),
            ]
        }
    }

    var poseInterval: CFTimeInterval = 0.3

    @IBInspectable
    var color: UIColor = .black {
        didSet {
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
        }
    }

    @IBInspectable
    var thickness: CGFloat = 2.0 {
        didSet {
            layer.lineWidth = thickness
        }
    }


    // toggle animation based on hidden state
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set {
            super.isHidden = newValue
            if !newValue { animate() }
        }
    }


    // MARK: - Setup / Teardown
    convenience init (color: UIColor) {
        self.init()
        self.color = color
    }


    override var layer: CAShapeLayer {
        get {
            return super.layer as! CAShapeLayer
        }
    }


    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }


    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        // setting bezier path
        setPath()

        // start animating when showing
        if !isHidden { animate() }
    }


    private func setPath() {
        layer.path = UIBezierPath(
            ovalIn: bounds.insetBy(dx: layer.lineWidth / 2,
                                   dy: layer.lineWidth / 2)
        ).cgPath
    }


    private func animate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()

        // total duration for each loop
        let totalSeconds = CFTimeInterval(poses.count - 1) * poseInterval

        for (index, pose) in poses.enumerated() {
            if index > 0 {
                time += poseInterval
            }

            times.append(time / totalSeconds)
            rotations.append(pose.start * 2 * .pi)
            strokeEnds.append(pose.length)
        }

        // finishing the loop by repeating first at the last position
        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])

        // animate
        animateKeyPath(keyPath: "strokeEnd",
                       duration: totalSeconds,
                       times: times,
                       values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation",
                       duration: totalSeconds,
                       times: times,
                       values: rotations)
    }


    private func animateKeyPath(keyPath: String,
                                duration: CFTimeInterval,
                                times: [CFTimeInterval],
                                values: [CGFloat])
    {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
}

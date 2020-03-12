//
//  LoadingView.swift
//  StudyCaptureApp
//
//  Created by Bastek on 3/11/20.
//  Copyright © 2020 Bastek. All rights reserved.
//

import UIKit


@IBDesignable
class LoadingView: UIView {

    // MARK: - Subviews and Contstraints
    private var blurEffectView: UIVisualEffectView?
    private var spinnerView: SpinnerView?

    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?

    // MARK: - UI
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var spinnerSize: CGFloat = 50.0 {
        didSet {
            widthConstraint?.constant = spinnerSize
            heightConstraint?.constant = spinnerSize
        }
    }

    @IBInspectable
    var spinnerColor: UIColor {
        get {
            return spinnerView?.color ?? .black
        }
        set {
            spinnerView?.color = newValue
        }
    }

    @IBInspectable
    var spinnerThickness: CGFloat {
        get {
            return spinnerView?.thickness ?? 4.0
        }
        set {
            spinnerView?.thickness = newValue
        }
    }


    // MARK: - Setup / Teardown
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupBackground()
        setupSpinner()
    }


    private func setupBackground() {
        if !UIAccessibility.isReduceTransparencyEnabled {
            self.backgroundColor = .clear

            // create a blur view and resize to fill parent
            let blurEffect = UIBlurEffect(style: .prominent)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(blurEffectView)

            self.blurEffectView = blurEffectView
        } else {
            // defaulting to semi-transparent background
        self.backgroundColor = UIColor.black.with(alpha: 0.5)
        }
    }


    private func setupSpinner() {
        let spinnerView = SpinnerView(color: UIColor(hex: 0x00398B))
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinnerView)

        // setup constraints to center-align our spinner
        spinnerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinnerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        widthConstraint = spinnerView.widthAnchor.constraint(equalToConstant: spinnerSize)
        heightConstraint = spinnerView.heightAnchor.constraint(equalToConstant: spinnerSize)
        widthConstraint?.isActive = true
        heightConstraint?.isActive = true

        self.spinnerView = spinnerView
    }


    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        // refresh spinner
        spinnerView?.setNeedsLayout()
    }
}

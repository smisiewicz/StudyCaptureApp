//
//  SubjectIdEntryViewController.swift
//  StudyCaptureApp
//
//  Created by Bastek on 3/11/20.
//  Copyright © 2020 Bastek. All rights reserved.
//

import UIKit


class SubjectIdEntryViewController: UIViewController {

    // MARK: - UI Elements and Constraints
    @IBOutlet weak var subjectIdTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var spinner: SpinnerView!

    @IBOutlet weak var bottomMarginConstraint: NSLayoutConstraint!


    //MARK: -
    private var subjectId: String?

    private var bottomMarginOffset: CGFloat?

    // adjust UI based on processing flag (quick and dirty)
    var isProcessing: Bool = false {
        didSet {
            // enable/disable controls
            spinner.isHidden = !isProcessing
            subjectIdTextField.isEnabled = !isProcessing
            continueButton.isEnabled = !isProcessing

            // reset error label
            errorLabel.text = nil
        }
    }


    // MARK: - Setup / Teardown
    override func viewDidLoad() {
        super.viewDidLoad()

        #if targetEnvironment(simulator)
        assert(false, "To run on devices only, no camera support on sim.")
        #endif

        setupKeyboardHandlers()
    }


    private func setupKeyboardHandlers() {
        self.bottomMarginOffset = bottomMarginConstraint.constant

        // just some keyboard boilerplate to smoothly adjust the content on smaller screens
        let center = NotificationCenter.default
        center.addObserver(forName: UIResponder.keyboardWillShowNotification,
                           object: nil,
                           queue: OperationQueue.main)
        { [weak self] (notification) in
            guard
                let keyboardFrame = notification.keyboardFrame,
                let duration = notification.duration else
            {
                return
            }

            let bottomMarginOffset = self?.bottomMarginOffset ?? 0.0
            self?.bottomMarginConstraint.constant = keyboardFrame.height + bottomMarginOffset

            UIView.animate(withDuration: duration) {
                self?.view.layoutIfNeeded()
            }
        }

        center.addObserver(forName: UIResponder.keyboardWillHideNotification,
                           object: nil,
                           queue: OperationQueue.main)
        { [weak self] (notification) in
            guard let duration = notification.duration else {
                return
            }

            let bottomMarginOffset = self?.bottomMarginOffset ?? 0.0
            self?.bottomMarginConstraint.constant = bottomMarginOffset

            UIView.animate(withDuration: duration) {
                self?.view.layoutIfNeeded()
            }
        }
    }


    // MARK: - Action Handlers
    @IBAction func onContinueTap(_ sender: Any) {
        // let's hide the keyboard and validate input before processing
        subjectIdTextField.resignFirstResponder()
        verifySubjectId()
    }


    private func verifySubjectId() {
        let result = SubjectIdValidator().validate(input: subjectIdTextField.text)

        switch result {
        case .valid(let result):
            // succeeded, start the process
            process(subjectId: result)

        case .invalid(let reason):
            // failed, show the error
            errorLabel.text = reason
        }
    }


    private func process(subjectId: String) {
        self.subjectId = subjectId
        captureSelfie()
    }
}


// MARK: Image Picker Delegation Extension
extension SubjectIdEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isProcessing = false
    }

    func captureSelfie() {
        self.isProcessing = true

        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.cameraDevice = .front
        vc.allowsEditing = true
        vc.delegate = self
        self.present(vc, animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }


    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker.dismiss(animated: true) {
            self.isProcessing = true

            guard
                let subjectId = self.subjectId,
                let subjectImage = info[.editedImage] as? UIImage,
                let storyboard = self.navigationController?.storyboard,
                let vc = storyboard.instantiateViewController(withIdentifier: "SubjectImageViewController") as? SubjectImageViewController
                else
            {
                // FIXME: total fubar
                return
            }

            vc.subjectData = SubjectData(subjectId: subjectId,
                                         subjectImage: subjectImage)
            self.show(vc, sender: self)
        }
    }
}

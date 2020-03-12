//
//  SubjectImageViewController.swift
//  StudyCaptureApp
//
//  Created by Bastek on 3/11/20.
//  Copyright © 2020 Bastek. All rights reserved.
//

import UIKit
import Photos


class SubjectImageViewController: UIViewController {

    // MARK: - UI Elements and Constraints
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var imageView: UIImageView!

    // MARK: -
    var subjectData: SubjectData?

    // adjust UI based on processing flag
    var isProcessing: Bool = false {
        didSet {
            // enable/disable controls
            loadingView.isHidden = !isProcessing
        }
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        process()
    }


    private func process() {
        self.isProcessing = true

        guard
            let subjectId = subjectData?.subjectId,
            let subjectImage = subjectData?.subjectImage else
        {
            //TODO: show a pretty failure screen
            return
        }

        // offload to background queue
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let maskedImage = subjectImage.unsharpMaskImage(radius: 11, intensity: 0.5)
            let processedImage = maskedImage.labeledImage(text: subjectId)

            DispatchQueue.main.async {
                self?.imageView.image = processedImage
                self?.isProcessing = false
            }
        }
    }


    // MARK: - Action Handlers
    @IBAction func onSaveTap(_ sender: Any) {
        // save it to spring ro..... I mean camera roll... I'm hungry.
        guard let image = self.imageView.image else {
            //TODO: show a pretty failure screen
            return
        }

        // start the process
        self.isProcessing = true

        // save
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            // comes back on a secondary thread, let's move it back to main
            DispatchQueue.main.async {
                self.isProcessing = false

                if success {
                    self.showSuccessAlert()
                } else {
                    //TODO: handle error here
                }
            }
        }
    }


    // MARK: -
    private func showSuccessAlert() {
        let alert = UIAlertController(title: "Image Saved",
                                      message: "success!",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        self.present(alert, animated: true)
    }
}

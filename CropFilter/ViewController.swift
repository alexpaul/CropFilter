//
//  ViewController.swift
//  CropFilter
//
//  Created by Alex Paul on 3/29/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private let imagePickerController = UIImagePickerController()
    
    //Update this for path line color
    private let strokeColor: UIColor = UIColor.blue
    
    //Update this for path line width
    private let lineWidth: CGFloat = 2.0
    
    //Path to draw while touch events occur
    private var path = UIBezierPath()
    
    //ShapeLayer of cropped view
    private var shapeLayer = CAShapeLayer()
    
    //Final Cropped Image
    private var croppedImage = UIImage()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.clipsToBounds = true 
        setupImagePickerController()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Library", style: .plain, target: self, action: #selector(showPhotoLibrary))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(showCamera))
    }
}

// MARK:- Cropping Functions
extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch?{
            let touchPoint = touch.location(in: imageView)
            print("touch begin to : \(touchPoint)")
            path.move(to: touchPoint)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch?{
            let touchPoint = touch.location(in: imageView)
            print("touch moved to : \(touchPoint)")
            path.addLine(to: touchPoint)
            addNewPathToImage()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch?{
            let touchPoint = touch.location(in: imageView)
            print("touch ended at : \(touchPoint)")
            path.addLine(to: touchPoint)
            addNewPathToImage()
            path.close()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch?{
            let touchPoint = touch.location(in: imageView)
            print("touch canceled at : \(touchPoint)")
            path.close()
        }
    }
    
    /**
     This methods is adding CAShapeLayer line to tempImageView
     */
    func addNewPathToImage(){
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        imageView.layer.addSublayer(shapeLayer)
    }
    
    /**
     This methods is making cropped object of tempImageView's image
     */
    func cropImage(){
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 1)
        
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        croppedImage = newImage!
    }
    
    @IBAction func IBActionCropImage(_ sender: UIButton) {
        shapeLayer.fillColor = UIColor.black.cgColor
        imageView.layer.mask = shapeLayer
        
        cropImage()
    }
    
    @IBAction func IBActionCancelCrop(_ sender: UIButton) {
        shapeLayer.removeFromSuperlayer()
        path = UIBezierPath()
        shapeLayer = CAShapeLayer()
    }
    
    @IBAction func showCroppedImage() {
        let croppedVC = CroppedImageController.storyboardInstance()
        croppedVC.image = croppedImage
        navigationController?.pushViewController(croppedVC, animated: true)
    }
}

// MARK:- Camera Functions
extension ViewController {
    private func setupImagePickerController() {
        imagePickerController.delegate = self
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            //cameraButtonItem.isEnabled = false
        }
    }
    
    private func showPickerController() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func checkAVAuthorizationStatus() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            print("authorized")
            showPickerController()
        case .denied:
            print("denied")
        case .restricted:
            print("restricted")
        case .notDetermined:
            print("nonDetermined")
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                if granted {
                    self.showPickerController()
                }
            })
        }
    }
    
    @objc private func showPhotoLibrary() {
        checkAVAuthorizationStatus()
        imagePickerController.sourceType = .photoLibrary
    }
    
    @IBAction private func showCamera(_ sender: UIBarButtonItem) {
        checkAVAuthorizationStatus()
        imagePickerController.sourceType = .camera
    }
}

// MARK:- UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
}


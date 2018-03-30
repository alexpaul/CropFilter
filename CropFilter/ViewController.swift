//
//  ViewController.swift
//  CropFilter
//
//  Created by Alex Paul on 3/29/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Update this for path line color
    let strokeColor:UIColor = UIColor.blue
    
    //Update this for path line width
    let lineWidth:CGFloat = 2.0
    
    //Path to draw while touch events occur
    var path = UIBezierPath()
    
    //ShapeLayer of cropped view
    var shapeLayer = CAShapeLayer()
    
    //Final Cropped Image
    var croppedImage = UIImage()

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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



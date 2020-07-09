//
//  ViewController.swift
//  ImageFilterEditor
//
//  Created by Joe on 7/7/20.
//  Copyright © 2020 AlphaGrade INC. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class ViewController: UIViewController {

    @IBOutlet weak var lambdaImageView: UIImageView!
    @IBOutlet weak var grayscaleSlider: UISlider!
    @IBOutlet weak var russianBlurSlider: UISlider!
    @IBOutlet weak var brightenSlider: UISlider!
    @IBOutlet weak var vortexDistortionSlider: UISlider!
    
    let blur = CIFilter.gaussianBlur()
    let distort = kCICategoryColorAdjustment
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lambdaImageView.image = UIImage(named: "iu.jpeg")
        
    }

    var lambdaImage: UIImage? {
        didSet {
           updateImage()
        }
    }
  
    func updateImage() {
        
    }
  
}


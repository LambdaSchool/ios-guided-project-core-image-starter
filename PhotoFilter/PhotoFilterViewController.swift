import UIKit
import CoreImage
import Photos
import CoreImage.CIFilterBuiltins

class PhotoFilterViewController: UIViewController {

	@IBOutlet weak var brightnessSlider: UISlider!
	@IBOutlet weak var contrastSlider: UISlider!
	@IBOutlet weak var saturationSlider: UISlider!
	@IBOutlet weak var imageView: UIImageView!
    
    var originalImage: UIImage?{
        didSet {
            updateImage()
        }
    }
    
    private let context = CIContext()
    private let filter = CIFilter.colorControls()
	
    override func viewDidLoad() {
		super.viewDidLoad()
//        let filter = CIFilter.gaussianBlur()
//        print(filter.attributes)
         originalImage = imageView.image
	}
	// MARK: Actions
    private func image(byFiltering image: UIImage) -> UIImage {
        let inputImage = CIImage(image: image)
        filter.inputImage = inputImage
        filter.saturation = saturationSlider.value
        filter.brightness = brightnessSlider.value
        filter.contrast = contrastSlider.value
        
        guard let outputImage = filter.outputImage else { return image}
        guard let renderedImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image}
        return UIImage(cgImage: renderedImage)
    }
    
    private func updateImage() {
        if let originalImage = originalImage {
            imageView.image = originalImage
        } else {
            imageView.image = nil
        }
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The photo library is not available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
	
	@IBAction func choosePhotoButtonPressed(_ sender: Any) {
		// TODO: show the photo picker so we can choose on-device photos
		// UIImagePickerController + Delegate
	}
	
	@IBAction func savePhotoButtonPressed(_ sender: UIButton) {
		// TODO: Save to photo library
	}
	

	// MARK: Slider events
	
	@IBAction func brightnessChanged(_ sender: UISlider) {

	}
	
	@IBAction func contrastChanged(_ sender: Any) {

	}
	
	@IBAction func saturationChanged(_ sender: Any) {

	}
}

extension PhotoFilterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, dsdidFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            originalImage = image
        } else if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}


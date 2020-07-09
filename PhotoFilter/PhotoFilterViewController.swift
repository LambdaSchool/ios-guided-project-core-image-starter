import UIKit
import CoreImage
import Photos
import CoreImage.CIFilterBuiltins

class PhotoFilterViewController: UIViewController {

	@IBOutlet weak var brightnessSlider: UISlider!
	@IBOutlet weak var contrastSlider: UISlider!
	@IBOutlet weak var saturationSlider: UISlider!
	@IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurSlider: UISlider!
    
    var originalImage: UIImage?{
        didSet {
            guard let originalImage = originalImage else {
            scaledImage = nil
                return
            }
            var scaledSize = imageView.bounds.size
            let scale = UIScreen.main.scale

            scaledSize = CGSize(width: scaledSize.width*scale, height: scaledSize.height*scale)
            guard let scaledUIImage = originalImage.imageByScaling(toSize: scaledSize) else { return }
//            scaledUIImage = originalImage.imageByScaling(toSize: scaledSize)
            scaledImage = CIImage(image: scaledUIImage)
        }
    }
    
    var scaledImage: CIImage? {
        didSet {
            
        }
    }
    
    private let context = CIContext()
    private let colorControlsFilter = CIFilter.colorControls()
    private let blurFilter = CIFilter.gaussianBlur()
	
    override func viewDidLoad() {
		super.viewDidLoad()
        let filter = CIFilter.gaussianBlur()
        print(filter.attributes)
         originalImage = imageView.image
	}
	// MARK: Actions
    private func image(byFiltering inputImage: CIImage) -> UIImage? {
        
        colorControlsFilter.inputImage = inputImage
        colorControlsFilter.saturation = saturationSlider.value
        colorControlsFilter.brightness = brightnessSlider.value
        colorControlsFilter.contrast = contrastSlider.value
        
        blurFilter.inputImage = colorControlsFilter.outputImage
        blurFilter.radius = blurSlider.value
        
        guard let outputImage = colorControlsFilter.outputImage else { return originalImage!}
        guard let renderedImage = context.createCGImage(outputImage, from: outputImage.extent) else { return originalImage!}
        return UIImage(cgImage: renderedImage)
    }
    
    private func updateImage() {
        if let scaledImage = scaledImage {
            imageView.image = image(byFiltering: scaledImage)
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
        guard let originalImage = originalImage, let ciImage = CIImage(image: originalImage) else { return }
        
        guard let processedImage = image(byFiltering: ciImage) else {return}
        
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: processedImage)
            }) { (success, error) in
                if let error = error {
                    print("Error saving photo. \(error)")
                    return
                }
                DispatchQueue.main.async {
                    self.presentSuccessfulSaveAlert()
                }
            }
        }
	}
	
    private func presentSuccessfulSaveAlert() {
        let alert = UIAlertController(title: "Photo Saved!", message: "The photo has been saved to your Photo Library!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            originalImage = image
        } else if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}


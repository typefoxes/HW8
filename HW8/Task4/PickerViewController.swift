// Pадание 4.2 напишите код, который с помощью swizzling’а добавляет в стандартный класс UIImagePickerController возможность сразу получить выбранную фотографию из галереи;

import UIKit

class PickerViewController: UIViewController {
    
    
    @IBOutlet weak var imageview: UIImageView!
    

    @IBAction func button(_ sender: UIButton) {
        
            self.picker.swizzling(vc: self, callback: { [weak self] output in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    self.imageview.image = output
                }
            })
    }
    

    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("identifier: \(self.view.identifier)")
    }
}

class PickedImage {

    var value: ((UIImage?) -> ())?
    init(_ value: @escaping (UIImage?) -> ()) {
        self.value = value
    }
}

extension UIImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    struct AssociatedKey {
        static var ImagePickedKey = "ImagePickedKey"
    }
    
    typealias ImagePicked = (UIImage?) -> (Void)
    var configurateImagePicked: ImagePicked? {
        get {
            print("getting ➡️")

            let img = objc_getAssociatedObject(
                self,
                &AssociatedKey.ImagePickedKey
            ) as? PickedImage
            return img?.value
        }
        set {
            print("setting ⬅️")
            objc_setAssociatedObject(
                self,
                &AssociatedKey.ImagePickedKey,
                
                PickedImage(newValue!),
                
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func swizzling(vc: UIViewController, callback: ImagePicked?) {
        print("swizzling: ✅")
        
        print("swizzlingPicker: [\(UIImagePickerController.swizzlingPicker)] -- OK")
        

        UIImagePickerController.swizzlingPicker.toggle()

        self.configurateImagePicked = callback
        
   
        vc.present(self, animated: true, completion: nil)
    }
    
    fileprivate static var swizzlingPicker: Bool = {
       
        let originalSelector = #selector(UIImagePickerController.imagePickerController(_:didFinishPickingMediaWithInfo:))
        let swizzledSelector = #selector(UIImagePickerController.extImagePickerController(_:didFinishPickingMediaWithInfo:))
        
      
        let instanceClass = UIImagePickerController.self
        
    
        let originalMethod = class_getInstanceMethod(instanceClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(instanceClass, swizzledSelector)
        
        let didAddMethod =
            class_addMethod(instanceClass, originalSelector,
                            method_getImplementation(swizzledMethod!),
                            method_getTypeEncoding(swizzledMethod!))
        
        if didAddMethod {
            print("didAddMethod: replaceMethod")
            class_replaceMethod(instanceClass, swizzledSelector,
                                method_getImplementation(originalMethod!),
                                method_getTypeEncoding(originalMethod!))
        } else {
            print("didAddMethod: exchange ")
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
        return true
    }()
    
    @objc public func extImagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let originalImage = info[.originalImage] as? UIImage
        
       
        self.configurateImagePicked?(originalImage)
        
        print("Finish Picking 👍")
        
        self.dismiss(animated: true, completion: {
            print("swizzlingPicker: [\(UIImagePickerController.swizzlingPicker)] -- OK")
            print("extImagePickerController: dismiss")
        })
    }
    
    @objc public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("Fail swizzling 🤦‍♂️")
        
        self.dismiss(animated: true, completion: {
            print("imagePickerController: dismiss")
        })
    }

}

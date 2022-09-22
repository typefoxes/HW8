import UIKit

// Pадание 4.1 добавьте в проект SegueSwizzler: https://drive.google.com/open?id=1xqRpsiNbUTsVFsJYsQUfXMvPwFqfZeTx, сделайте несколько переходов на другие экраны с передачей данных на них с помощью нового performSegue

class SwizzlerViewController: UIViewController {

    
    @IBOutlet weak var textField: UITextField!
 
    @IBAction func button(_ sender: UIButton) {
        guard textField.text?.isEmpty == false else { return }
        
        performSegueWithIdentifier(identifier: "FirstVC", sender: sender) { segue in
            let vc = segue.destination as? FirstVC
            vc?.text = self.textField.text!
            self.textField.text = nil
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit { print("\(self.classForCoder) deinit -- \(Date())") }
}

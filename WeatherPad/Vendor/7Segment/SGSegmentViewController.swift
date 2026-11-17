
import UIKit

class SGSegmentViewController: UIViewController {

    @IBOutlet public var segments: [SGSegmentView]?
    
    
    public var color: UIColor {
        didSet {
            for seg in segments! {
                seg.fillColor = color
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.color = UIColor.clear
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.color = UIColor.clear
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

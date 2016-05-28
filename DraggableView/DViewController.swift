

import UIKit

class DViewController: UIViewController {
    
    @IBOutlet weak var d1: DraggableView!
    @IBOutlet weak var T2: UIView!
    
    @IBOutlet weak var T3: UIView!
    @IBOutlet weak var t1: UIView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        d1.dropTarget = t1
        d1.dropTarget = T2
        d1.dropTarget = T3
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
}


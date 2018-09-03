import UIKit
extension UIStoryboard {
    public class func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: identifier, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}

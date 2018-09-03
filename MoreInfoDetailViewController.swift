import UIKit
class MoreInfoDetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var item: MenuItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false)
    }
    private func setupUI() {
        title = item?.title
        textView.text = item?.info
    }
}

import UIKit
import AlamofireImage
import SafariServices
class EventDetailsViewController: UIViewController {
    public var eventDetails: EventDetailsViewModel?
    private var detailsView: EventDetailsView {
        return view as! EventDetailsView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI() {
        guard let eventDetails = eventDetails else { return }
        title = eventDetails.name
        setConfigurationHandler()
        detailsView.urlOpeningHandler = { url in
            DispatchQueue.main.async {
                if !UIApplication.shared.canOpenURL(url) {
                    let alert = UIAlertController(title: nil, message: "URL is invalid.", preferredStyle: .alert)
                    self.present(alert, animated: true) {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }
                } else {
                    let safariVC = SFSafariViewController(url: url)
                    self.present(safariVC, animated: true)
                }
            }
        }
        detailsView.configure(with: eventDetails)
    }
    private func setConfigurationHandler() {
        detailsView.configurationHandler = { [weak self] in
            if let imageName = self?.eventDetails?.imageName {
                let imageConfigurator = ImageConfigurator(imageName: imageName)
                if let appBundleImage = UIImage(named: imageName) {
                    self?.detailsView.imageView.image = appBundleImage
                } else {
                    if FileManager.default.fileExists(atPath: imageConfigurator.imagePathURL.path) {
                        if let image = imageConfigurator.loadImage() {
                            self?.detailsView.imageView.image = image
                            return
                        }
                    }
                    self?.detailsView.imageView.af_setImage(
                        withURL: imageConfigurator.downloadImageURL,
                        placeholderImage: UIImage(named:"NCCBF-2018-icon-image"),
                        imageTransition: .crossDissolve(0.5),
                        runImageTransitionIfCached: false,
                        completion: { (dataResponse) in
                            guard let data = dataResponse.data else { return }
                            if !FileManager.default.fileExists(atPath: imageConfigurator.imagePathURL.path) {
                                imageConfigurator.saveImageToCachesDirectory(imageData: data)
                            }
                    })
                }
            } else {
                self?.detailsView.imageView.image = UIImage(named:"NCCBF-2018-icon-image")
            }
        }
    }
}

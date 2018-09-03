import UIKit
class EventCatalogTableViewCell: UITableViewCell {
    class var ReuseIdentifier: String { return "\(type(of: self))" }
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailView.af_cancelImageRequest()
        thumbnailView.layer.removeAllAnimations()
        thumbnailView.image = nil
    }
    func configure(with event: Event) {
        self.titleLabel.text = event.name
        self.thumbnailView.configure(with: event)
    }
}

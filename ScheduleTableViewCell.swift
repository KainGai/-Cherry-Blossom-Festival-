import UIKit
class ScheduleTableViewCell: UITableViewCell {
    class var ReuseIdentifier: String { return "\(type(of: self))" }
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(with event: Event) {
        startTimeLabel.text = event.startAt.string
        endTimeLabel.text = event.endAt?.string ?? "All day"
        titleLabel.text = event.name
    }
}

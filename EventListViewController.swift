import UIKit
class EventListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let events: [Event]
    weak var tableView: UITableView!
    let tableViewStyle: UITableViewStyle
    let reuseIdentifier = "reuseIdentifier"
    init(events: [Event], tableViewStyle: UITableViewStyle) {
        self.events = events
        self.tableViewStyle = tableViewStyle
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        self.view = UITableView(frame: view.bounds, style: tableViewStyle)
        tableView = self.view as! UITableView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let event = events[indexPath.row]
        cell.textLabel?.text = event.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        let eventDetails = EventDetailsViewModel(event: event)
        let vc = UIStoryboard.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
        vc.eventDetails = eventDetails
        navigationController?.pushViewController(vc, animated: true)
    }
}

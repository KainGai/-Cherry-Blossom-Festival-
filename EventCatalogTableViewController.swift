import UIKit
import CoreData
class EventCatalogTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var context: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<Event>?
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFetchedResultsController()
        setupTableView()
        setupUI()
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCatalogTableViewCell.ReuseIdentifier, for: indexPath) as! EventCatalogTableViewCell
        guard let event = fetchedResultsController?.object(at: indexPath) else { return cell }
        cell.configure(with: event)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let event = fetchedResultsController?.object(at: indexPath) else { return }
        let eventDetails = EventDetailsViewModel(event: event)
        let storyboard = UIStoryboard(name: "EventDetailsViewController", bundle: Bundle.main)
        if let vc = storyboard.instantiateInitialViewController() as? EventDetailsViewController {
            vc.eventDetails = eventDetails
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func setupUI() {
        title = "Events"
    }
    private func initializeFetchedResultsController() {
        guard let context = context else { return }
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let idSort = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [idSort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
    }
}

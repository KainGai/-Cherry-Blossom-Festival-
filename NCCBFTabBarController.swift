import UIKit
class NCCBFTabBarController: UITabBarController {
    var eventCatalogTableViewController: EventCatalogTableViewController {
        let nc = viewControllers?[0] as? UINavigationController
        return nc?.topViewController as! EventCatalogTableViewController
    }
    var scheduleTableViewController: ScheduleTableViewController {
        let nc = viewControllers?[1] as? UINavigationController
        return nc?.topViewController as! ScheduleTableViewController
    }
    var mapViewController: MapViewController {
        let nc = viewControllers?[2] as? UINavigationController
        return nc?.topViewController as! MapViewController
    }
    var moreInfoTableViewController: MoreInfoTableViewController {
        let nc = viewControllers?[3] as? UINavigationController
        return nc?.topViewController as! MoreInfoTableViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .sakuraPink
    }
}

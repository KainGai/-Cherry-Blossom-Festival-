import UIKit
import MapKit
import CoreData
import CoreLocation
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,NSFetchedResultsControllerDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    var context: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<Event>?
    let reuseIdentifier = "resueIdentifier"
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var Weather2D: CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentCityLoaction()
        addWeatherButton()
        initializeFetchedResultsController()
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
        guard let sections = fetchedResultsController?.sections else { return }
        mapView.addAnnotations(EventLocationAnnotationFactory.createAnnotations(with: sections))
        setupUI()
        setupMapView()
        goToDefaultLocation()
    }
    func getCurrentCityLoaction()
    {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
        locationManager.requestWhenInUseAuthorization()
        return
        }
        if authStatus == .denied || authStatus == .restricted {
        showLocationServicesDeniedAlert()
        return
        }
        startLocationManager()
    }
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",message:"Please enable location services for this app in Settings.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
      func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print ("here")
        let newLocation = locations.last!
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            print("too old")
            return
        }
        if newLocation.horizontalAccuracy < 0 {
            print ("less than 0")
            return
        }
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy   {
            print ("improving")
            location = newLocation
            Weather2D = newLocation.coordinate
            locationManager.stopUpdatingLocation()
            return
        }
    }
    func addWeatherButton(){
        let btnAction = UIButton(frame:CGRect(x:0, y:0, width:18, height:18))
        btnAction.setTitle("☁️", for: .normal)
        btnAction.addTarget(self,action:#selector(GotoWeatherAction(sender:)),for:.touchUpInside)
        let itemAction=UIBarButtonItem(customView: btnAction)
        self.navigationItem.leftBarButtonItem=itemAction
    }
    func GotoWeatherAction(sender:UIBarButtonItem)
    {
        if(location?.coordinate.latitude == 0.0 || location?.coordinate.longitude == 0.0 || location == nil || Weather2D == nil)
        {
            showLocationFauseAlert()
        }
        else
        {
        let WeatherView:WeatherViewController = WeatherViewController()
            WeatherView.loaction = location
            WeatherView.lat  = (Weather2D?.latitude)!
            WeatherView.lng = (Weather2D?.longitude)!
        present(WeatherView, animated: true, completion: nil)
        }
    }
    func showLocationFauseAlert() {
        let alert = UIAlertController(title: "Propmt",message:"No current location found,Please check whether to run the app for location permission,Or try clicking on the weather again after clicking ‘ok’", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){ action in
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            self.locationManager.startUpdatingLocation()
            }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    private func showTableView(with annotation: EventLocationAnnotation) {
        let eventListVC = EventListViewController(events: annotation.events, tableViewStyle: .grouped)
        eventListVC.title = annotation.title
        navigationController?.pushViewController(eventListVC, animated: true)
    }
    private func initializeFetchedResultsController() {
        guard let context = context else { return }
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let idSort = NSSortDescriptor(key: "location", ascending: true)
        request.sortDescriptors = [idSort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "location", cacheName: nil)
        fetchedResultsController?.delegate = self
    }
    private func setupUI() {
        title = "Map"
    }
    private func setupMapView() {
        mapView.delegate = self
    }
    private func goToDefaultLocation() {
        mapView.setRegion(MKCoordinateRegion(center: defaultLocationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.008  , longitudeDelta: 0.008)), animated: true)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) else {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.tintColor = .sakuraPink
            pinAnnotationView.rightCalloutAccessoryView = rightButton
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            pinAnnotationView.pinTintColor = .sakuraPink
            return pinAnnotationView
        }
        return annotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? EventLocationAnnotation else { return }
        showTableView(with: annotation)
    }
}

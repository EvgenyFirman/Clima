// Weather App By Eugene Firman

// Importing Libraries
import UIKit
import CoreLocation

// Initializing class WeatherViewController
class WeatherViewController: UIViewController {
    
    // Initializing IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    // Initializing access to weatherApi structure
    var weatherAPI = WeatherAPIBrain()
    
    // Initializing acess to location manager library
    var locationManager = CLLocationManager()
    
    // Override func viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set Up delegating on location Manager
        locationManager.delegate = self
        // Initializing request when in use authorization
        locationManager.requestWhenInUseAuthorization()
        // Initializing request on location
        locationManager.requestLocation()
        weatherAPI.delegate = self
        // Do any additional setup after loading the view.
        titleTextField.delegate = self
    }
    
    // Reseting GeoPosition while tapping on default position button
    @IBAction func defaultLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    // End editing on click on search button
    @IBAction func searchButton(_ sender: UIButton) {
        titleTextField.endEditing(true)
    }
}

// Weather View controller protocol extension
extension WeatherViewController: WeatherManagerDelegate {
   
    // Update weather function
    func didUpdateWeather(weather: WeatherStruct){
        // Async dispatchQueue Method
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperature
            self.conditionImageView.image = UIImage(systemName: weather.computedValue)
            self.cityLabel.text = weather.name
        }
    }
    // Catch Error for testing function
    func didCatchError(error: Error) {
        print(error)
    }
}

// WeatherViewController for UITextFieldDelegate extension
extension WeatherViewController:  UITextFieldDelegate{
    // UITextField extension textFieldShouldReturn
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.endEditing(true)
        print(titleTextField.text!)
        return true
    }
    // TextFieldDidEndEditing override method
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            weatherAPI.getCity(city: city)
        }
        titleTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        } else {
            textField.placeholder = "Enter city please"
            return false
        }
    }
}
// Weather View Controller location manager extension
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherAPI.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}



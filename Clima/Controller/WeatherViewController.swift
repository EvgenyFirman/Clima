//
//  ViewController.swift
//  Clima

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherAPI = WeatherAPIBrain()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherAPI.delegate = self
        // Do any additional setup after loading the view.
        titleTextField.delegate = self
        
    }

    @IBAction func defaultLocation(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
    @IBAction func searchButton(_ sender: UIButton) {
        titleTextField.endEditing(true)
    }
    
}

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(weather: WeatherStruct){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperature
            self.conditionImageView.image = UIImage(systemName: weather.computedValue)
            self.cityLabel.text = weather.name
            
        }
    }
    func didCatchError(error: Error) {
        print(error)
    }
}

extension WeatherViewController:  UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.endEditing(true)
        print(titleTextField.text!)
        return true
    }
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



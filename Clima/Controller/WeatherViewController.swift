//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
//for GPS we use CoreLocation
import CoreLocation

//step 4) adding that delegate "protocol"
class WeatherViewController: UIViewController
{
    var weatherManager = WeatherManager()
    //the coreLocation that we imported we can assign it to valuable
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var SearchTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //for this delegate to send the info it get we have to include the locationManager.delegate = self
        /*
         however for us to have the info we have to declear the self before requestion anything not after
         When using this method, the associated delegate must implement the
         locationManager(_:didUpdateLocations:) and locationManager(_:didFailWithError:) methods.
         Failure to do so is a programmer error.
         */
        locationManager.delegate = self
        /*
         asking for permission request from the coreloaction for the GPS with asking the user for permission
         frthermore, we have to go to the info plist which the proporty list and add new proporty which is location privay when the use usage description and the message of which it will be shown to the user
         */
        locationManager.requestWhenInUseAuthorization()
        /*
         now we have to request the location which is one time reuest but if we want to alayws know the location we have to use
         -> startUpdatingLocaiotion()
         */
        locationManager.requestLocation()
        //step 5) and this way our weathermanafer in the weather manager file is not equal to nil
        weatherManager.delegate = self
        SearchTextField.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton)
    {
        locationManager.requestLocation()
    }
    
}
//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate
{
    /*
     for this delegate to work and it get the values that we want we have to add
     locationManager.delegate = self in the viewDidLoad Never fogert that because without it it will not work
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //because last is option then we have to optional bind the whole thing
        if let location = locations.last
        {
            //this used to stop looking for another location once it already has one 
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat , longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
         print("error")
         
    }
    
}//MARK: - UITextFieldDelegate

/*
 Here I will be adding my extension so that it will help clean up the clode that have included in the main class
 it has to have to the same name of the class of which we will extend with the delegate that we want the extension
 to be added it to it, and because so we have to deleted from the main class becaue it has been redundant to have it
 twice
 */
extension WeatherViewController: UITextFieldDelegate
{
    @IBAction func searchPressed(_ sender: UIButton) {
        SearchTextField.endEditing(true)
    }
    //delegate method and it is called completion handler which is used for networkinh
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        SearchTextField.endEditing(true)
        return true
    }
    //delegate method and it is called completion handler which is used for networking
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        if textField.text != ""
        {
            return true
        }
        else
        {
            textField.placeholder = " type something here"
            return false
        }
    }
    //delegate method and it is called completion handler which is used for networking
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if let city = SearchTextField.text
        {
            weatherManager.fetchWeather(cityName: city)
        }
        
        SearchTextField.text = ""
    }
}
//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate
{
    /*
     this a competion handler and for us to change anything in the user interface
     we have to call the main thread and then update our user interface in the background
     */
    func didUpdateWeather (_ weatherManger: WeatherManager, weather: WeatherModel)
    {
        DispatchQueue.main.async
            {
                //because it is closure we have to add "self" to it
                self.temperatureLabel.text = weather.temperatureString
                self.conditionImageView.image = UIImage(systemName: weather.conditionName)
                self.cityLabel.text = weather.cityName
        }
    }
    //to print out the error if it was there
    func didFallWithError(error: Error) {
        print(error )
    }
    
}





































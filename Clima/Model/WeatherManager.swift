//
//  WeatherManager.swift
//  Clima
//
//  Created by Mero on 2020-04-29.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
//for GPS we use CoreLocation
import CoreLocation

//we create the protocol in the same file as we will use the protocol
//step 1)
protocol WeatherManagerDelegate
{
    func didUpdateWeather(_ weatherManger: WeatherManager, weather: WeatherModel)
    //the input is error of type Error
    func didFallWithError( error : Error)
}

struct WeatherManager
{
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=a61085bb415c06e8a8f7a4d1735dd811&units=metric"
    //Step 2)
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String)
    {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with : urlString)
    }
    //how to choose the date tpe is by clicking option key on lon and it will tell us it is CLLoctionDegrees
    func fetchWeather(latitude: CLLocationDegrees , longitude: CLLocationDegrees)
    {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with : urlString)
        
    }
    
    //with is for external usage and urlString is for internal usage
    func performRequest (with urlString: String )
    {
        //In here we will carry the four steps of networking to make the url fetch for us the info that we are looking for
        // 1. Create a URL
        if let url = URL(string: urlString)
        {
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            // 3. Give the session a task whcih is to go to a browser and use the URL
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil
                {
                    //always inside clossure we have to include self
                    self.delegate?.didFallWithError(error: error!)
                    return
                }
                
                
                if let safeData = data
                {
                    //using closure we have to use self to include a method that is inside the same class
                    //using optional binding is checked to see if it's nil or has data. If it's nil, the if-statement just doesn't get executed. If there's data, the data gets unwrapped and assigned to constantName for the scope of the if-statement. Then the code inside the braces is executed.
                    if let weather =  self.parseJASON(safeData)
                    {
                        //Step 3) and we have to use self to specifiy that we are in the same class
                        self.delegate?.didUpdateWeather(  self, weather: weather)
                    }
                }
            }
            // 4. Start the task which basically hitting enter in the search bar to go to the webpage with the info
            task.resume()
        }
    }
    
    //the reason we choose the return to be weatherModel datatype because that is what weather is created from
    func parseJASON (_ weatherData: Data) -> WeatherModel?
    {
        let decoder = JSONDecoder()
       do
       {
            let decodedData = try decoder.decode(WeatherData.self , from: weatherData)
            print(decodedData.main.temp)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        }
        catch
        {
            delegate?.didFallWithError(error: error)
            //for us to return nil we have to make our weatherModul as optional by adding ?
            return nil
        }
    }
    
}

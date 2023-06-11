//
//  weatherManager.swift
//  Clima
//
//  Created by mac on 29/10/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager,weather:WeatherModel)
    func didFailWithError(error:Error)
}

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=2c50049e2f4d268e13b2f6f23b749741&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityname:String){
        let urlString = "\(weatherUrl)&q=\(cityname)"
        print(urlString)
        performRequest(with:urlString)
    }
    
    func fetchWeather(lat:CLLocationDegrees, long:CLLocationDegrees){
        let urlString = "\(weatherUrl)&lat=\(lat)&lon=\(long)"
        performRequest(with:urlString)
    }
    
    func performRequest(with urlString:String) {
        
        let request =  AF.request(urlString)
        request.responseDecodable(of:WeatherData.self) { response in
            guard let response = response.value else {return}
            let weather =  WeatherModel(conditionId: response.weather[0].id, cityName: response.name, temprature: response.main.temp)
            self.delegate?.didUpdateWeather(self, weather: weather)
        }
        //1 creat a url
//        if let url  = URL(string: urlString) {
//            //2 creat url session
//            let session = URLSession(configuration: .default)
//            //3 give the session a task
//
//            let task  = session.dataTask(with: url) { data, response, error in
//                if error != nil {
//                    print(error!)
//                    self.delegate?.didFailWithError(error: error!)
//                    return
//                }
//                if let safeData = data {
//                    if let weather = self.parseJSON(safeData) {
//                        self.delegate?.didUpdateWeather(self, weather: weather)
//                    }
//                }
//            }
//
//            //4 start the task
//            task.resume()
//        }
    }
    
//    func parseJSON(_ weatherData:Data) -> WeatherModel? {
//        let decoder = JSONDecoder()
//        do {
//            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
//            print(decodedData.main.temp)
//            
//            let id = decodedData.weather[0].id
//            let temp = decodedData.main.temp
//            let name = decodedData.name
//            
//            let weather = WeatherModel(conditionId: id, cityName: name, temprature: temp)
//            print(weather.conditionName)
//            print(weather.tempString)
//            return weather
//        } catch {
//            delegate?.didFailWithError(error: error)
//            return nil
//        }
//    }
    
    
    
}

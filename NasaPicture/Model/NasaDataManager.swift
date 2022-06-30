//
//  NasaDataManader.swift
//  NasaPicture
//
//  Created by Lyudmila Tokar on 3/25/21.
//

import Foundation

protocol NasaDataManagerDelegate {
    func didUpdateNasaData(_ nasaDataManager: NasaDataManager, nasaData: NasaDataModel)
    func didFailWithError(error: Error)
}

struct NasaDataManager {
    
    var dataManagerDelegate: NasaDataManagerDelegate?
    
    let baseURL = "https://api.nasa.gov/planetary/apod?api_key=qx85DKUi7WUydT7htIw36uIQHKKc5qlfQ06X23yR"
    
    func fetchNasaData (data: String) {
        let urlString = "\(baseURL)&date=\(data)"
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    dataManagerDelegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    if let nasaData = parseJSON(safeData) {
                        dataManagerDelegate?.didUpdateNasaData(self, nasaData: nasaData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ nasaData: Data) -> NasaDataModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(NasaData.self, from: nasaData)
            let title = decodedData.title
            let description = decodedData.explanation
            let urlImage = decodedData.url
            
            let nasaDecoded = NasaDataModel(titleImage: title, description: description, urlImage: urlImage)
        
            return nasaDecoded
        } catch {
            dataManagerDelegate?.didFailWithError(error: error)
            return nil
        }
    }
}

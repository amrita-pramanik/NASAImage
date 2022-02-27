//
//  NetworkApiData.swift
//  FindImages
//
//  Created by Amrita on 25/02/22.
//

import Foundation

struct NetworkApiService {
    
    func getData(forDate: String?, completion : @escaping (NASAImageDataObject?) -> ())
    {
        let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=lkUjSfbhKwEO1TUASa6n93wxeWMBKrazQfjzlELR&date=\(forDate ?? "")")!
    
        URLSession.shared.dataTask(with: url) { data, response, error in
        
        if let error = error {
            print("Error = \(error)")
        }
        else {
            do {
                if let responseData = data {
                    
                    let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let responseData = try decoder.decode(NASAImageDataObject.self, from: responseData)
                    completion(responseData)
                }
            }
            catch {
                print("Catch :", error.localizedDescription)
            }
        }
        }.resume()
    }
}

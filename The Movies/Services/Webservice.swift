//
//  Webservice.swift
//  The Movies
//
//  Created by Bruno Costa on 30/01/23.
//

import Foundation

enum ServiceError: Equatable, Error {
  case CannotFetch(String = "An error ocurred." + " Tap here to try again.")
}

final class Webservice {
    func fetchMovies(url: URL, completion: @escaping ([Movie]?, ServiceError?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> () in
    
            do {
                if error != nil {
                    completion(nil, ServiceError.CannotFetch())
                    return
                }
                guard let data = data else {
                    completion(nil, ServiceError.CannotFetch())
                    return
                }
                
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MovieList.self, from: data)
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(jsonData.results, nil)
                }
            } catch {
                completion(nil, ServiceError.CannotFetch())
            }
        }).resume()
    }
    
    func fetchGenres(url: URL, completion:  @escaping ([Genre]?, ServiceError?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> () in
    
            do {
                if error != nil {
                    completion(nil, ServiceError.CannotFetch())
                    return
                }
                guard let data = data else {
                    completion(nil, ServiceError.CannotFetch())
                    return
                }

                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(GenreList.self, from: data)
                
                DispatchQueue.main.async {
                    completion(jsonData.genres, nil)
                }
            } catch {
                completion(nil, ServiceError.CannotFetch())
            }
        }).resume()
    }
}

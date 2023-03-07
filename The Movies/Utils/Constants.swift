//
//  Constants.swift
//  The Movies
//
//  Created by Bruno Costa on 30/01/23.
//

import Foundation

struct Constants {
    
    struct API_KEY {
        static let key = "your_api_key_here"
    }
    
    struct Urls {
       
        static func urlForPopularMovies(page: Int = 1) -> URL {
            return URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(API_KEY.key)&language=en-US&page=\(page)")!
        }
        static func urlForPosterMovies(poster_path: String) -> URL {
            return URL(string: "https://image.tmdb.org/t/p/w500\(poster_path)")!
        }
        
        static func urlForGenres() -> URL {
            return URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(API_KEY.key)&language=en-US")!
        }
    }
}

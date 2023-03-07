//
//  Movie.swift
//  The Movies
//
//  Created by Bruno Costa on 27/01/23.
//

import Foundation

struct Movie: Decodable {
    let poster_path: String
    let overview: String
    let release_date: String
    let original_title: String
    let title: String
    let id: Int
    let genre_ids: [Int]
}

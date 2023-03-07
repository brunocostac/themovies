//
//  Genre.swift
//  The Movies
//
//  Created by Bruno Costa on 31/01/23.
//

import Foundation

struct GenreList: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable {
    let id: Int
    let name: String
}

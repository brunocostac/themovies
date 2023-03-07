//
//  Motive.swift
//  The Movies
//
//  Created by Bruno Costa on 27/01/23.
//

import Foundation

struct MovieList: Decodable {
    let page: Int
    let results: [Movie]
}

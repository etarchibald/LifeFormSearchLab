//
//  Results.swift
//  lifeFormSearch
//
//  Created by Ethan Archibald on 12/13/23.
//

import Foundation

struct Results: Decodable {
    var results: [SearchAnimal]
    
    enum CodingKeys: CodingKey {
        case results
    }
}

struct SearchAnimal: Decodable {
    var id: Int
    var title: String
    var content: String
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case content
    }
}

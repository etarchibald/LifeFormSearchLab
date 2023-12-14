//
//  Entry.swift
//  lifeFormSearch
//
//  Created by Ethan Archibald on 12/13/23.
//

import Foundation

struct Hierarchy: Decodable {
    var entry: Entry
    var nameAccordingTo: [String]
    var ancestors: [Ancestors]
    
    enum CodingKeys: CodingKey {
        case entry
        case nameAccordingTo
        case ancestors
    }
}

struct Entry: Decodable {
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "canonical_form"
    }
}

struct Ancestors: Decodable {
    var name: String
    var taxonRank: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "scientificName"
        case taxonRank = "taxonRank"
    }
}

//
//  TaxonConcept.swift
//  lifeFormSearch
//
//  Created by Ethan Archibald on 12/13/23.
//

import Foundation

struct TaxonConcept: Decodable {
    var taxonConcept: TaxonConceptInner
    
    enum CodingKeys: CodingKey {
        case taxonConcept
    }
}

//struct DataObjects: Decodable {
//    var dataInfo: [DataInfo]
//
//    enum CodingKeys: String, CodingKey {
//        case dataInfo = "dataObjects"
//    }
//}
    
struct TaxonConceptInner: Decodable {
    var taxon: [TaxonInfo]
    var dataObjects: [DataInfo]
        
    enum CodingKeys: String, CodingKey {
        case taxon = "taxonConcepts"
        case dataObjects
    }
}
    
    
struct TaxonInfo: Decodable {
    var id: Int
    var name: String
    var accordingTo: String
        
    enum CodingKeys: String, CodingKey {
        case id = "identifier"
        case name = "scientificName"
        case accordingTo = "nameAccordingTo"
    }
}


struct DataInfo: Decodable {
    var imageURL: URL
    var license: String
    var agents: [Agents]
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "eolMediaURL"
        case license = "license"
        case agents = "agents"
    }
}

struct Agents: Decodable {
    var fullName: String
    var role: String
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case role = "role"
    }
}

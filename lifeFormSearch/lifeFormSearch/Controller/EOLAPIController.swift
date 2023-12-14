//
//  EOLAPIController.swift
//  lifeFormSearch
//
//  Created by Ethan Archibald on 12/13/23.
//

import Foundation
import UIKit

class EOLAPIController {
    
    static var shared = EOLAPIController()
    
    func fetchEOLSearch(with searchTerm: String) async throws -> [SearchAnimal] {
        var urlComponents = URLComponents(string: "https://eol.org/api/search/1.0.json?page=1&key=")!
        
        let search = URLQueryItem(name: "q", value: searchTerm)
        urlComponents.queryItems = [search]
        
        let (data, _) = try await URLSession.shared.data(from: urlComponents.url!)
        
        let searchResponse = try JSONDecoder().decode(Results.self, from: data)
        return searchResponse.results
    }
    
    func fetchEOLPages(with searchID: String) async throws -> TaxonConcept {
        let urlComponents = URLComponents(string: "https://eol.org/api/pages/1.0/\(searchID).json?details=true&images_per_page=10")!
        
        print(urlComponents)
        
        let (data, _) = try await URLSession.shared.data(from: urlComponents.url!)
        let searchResponse = try JSONDecoder().decode(TaxonConcept.self, from: data)
        return searchResponse
    }
    
    func fetchImage(with url: URL) async -> UIImage {
        let data = try? Data(contentsOf: url)
        return UIImage(data: data ?? Data()) ?? UIImage(systemName: "photo")!
    }
    
    func fetchHierarchy(with searchID: String) async throws -> Hierarchy {
        let url = URL(string: "https://eol.org/api/hierarchy_entries/1.0/\(searchID).json?language=en")!
        print(url)
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let searchResponse = try JSONDecoder().decode(Hierarchy.self, from: data)
        return searchResponse
    }
    
}

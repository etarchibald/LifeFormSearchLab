//
//  EOLAPIController.swift
//  lifeFormSearch
//
//  Created by Ethan Archibald on 12/13/23.
//

import Foundation

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
    
}

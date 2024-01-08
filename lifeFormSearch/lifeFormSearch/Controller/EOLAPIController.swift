//
//  EOLAPIController.swift
//  lifeFormSearch
//
//  Created by Ethan Archibald on 12/13/23.
//

import Foundation
import UIKit

protocol APIRequest {
    associatedtype Response
    
    var urlRequest: URLRequest { get }
    func decodeData(_ data: Data) throws -> Response
}

enum APIError: Error {
    case youSuck
}

struct EOLSearch: APIRequest {
    var searchTerm: String
    
    var urlRequest: URLRequest {
        var components = URLComponents(string: "https://eol.org/api/search/1.0.json?page=1&key=")!
        let search = URLQueryItem(name: "q", value: searchTerm)
        components.queryItems = [search]
        return URLRequest(url: components.url!)
    }
    
    func decodeData(_ data: Data) throws -> [SearchAnimal] {
        let searchResults = try JSONDecoder().decode(Results.self, from: data)
        return searchResults.results
    }
}

struct FetchEOLPages: APIRequest {
    
    var searchID: String
    
    var urlRequest: URLRequest {
        let urlComponents = URLComponents(string: "https://eol.org/api/pages/1.0/\(searchID).json?details=true&images_per_page=10")!
        return URLRequest(url: urlComponents.url!)
    }
    
    func decodeData(_ data: Data) throws -> TaxonConcept {
        return try JSONDecoder().decode(TaxonConcept.self, from: data)
    }
}

struct FetchEOLHierarchy: APIRequest {
    var searchID: String
    
    var urlRequest: URLRequest {
        let url = URL(string: "https://eol.org/api/hierarchy_entries/1.0/\(searchID).json?language=en")!
        return URLRequest(url: url)
    }
    
    func decodeData(_ data: Data) throws -> Hierarchy{
        return try JSONDecoder().decode(Hierarchy.self, from: data)
    }
}

struct ImageAPIRequest: APIRequest {
    var url: URL
    
    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }
    
    func decodeData(_ data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else { throw APIError.youSuck }
        return image
    }
}

class EOLAPIController {
    
    static var shared = EOLAPIController()
    
    func sendRequest<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        let session = URLSession.shared
        let (data, response) = try await session.data(for: request.urlRequest)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            throw APIError.youSuck
        }
        return try request.decodeData(data)
    }
}

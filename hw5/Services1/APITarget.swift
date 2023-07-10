//
//  APITarget.swift
//  hw4_new
//
//  Created by Arina Goncharova on 07.07.2023.
//

import Moya
import Foundation

enum APITarget {
    case getCharacters
}

extension APITarget: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string:"https://rickandmortyapi.com") else {
            fatalError("Cannot get url")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .getCharacters:
            return "/api/character"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        .requestParameters(parameters: [
            "page": 1
        ], encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

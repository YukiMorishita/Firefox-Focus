//
//  SearchEngine.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/23.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

enum SearchEngineType {
    case none
    case amazon
    case duckDuckGo
    case google
    case twitter
    case wikipedia
}

class SearchEngine {
    let type: SearchEngineType
    
    init(type: SearchEngineType) {
        self.type = type
    }
    
    func url(for search: String) -> URL? {
        guard let escapedSearch = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        switch type {
        case .amazon:           return URL(string: "")
        case .duckDuckGo:       return URL(string: "https://duckduckgo.com/?q=" + escapedSearch)
        case .google:           return URL(string: "https://www.google.com/search?q=" + escapedSearch)
        case .twitter:          return URL(string: "")
        case .wikipedia:        return URL(string: "https://\(NSLocalizedString("localized wikipedia domain", comment: "domain for wikipedia in the language used by the user"))/wiki/" + escapedSearch)
        case .none:             return nil
        }
    }
}

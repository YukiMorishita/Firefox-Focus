//
//  SearchEngineSuggestion.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/23.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

private let maxCount = 3

class SearchEngineSuggestionSource {
    var engine: SearchEngine
    
    init(engine: SearchEngine) {
        self.engine = engine
    }
    
    func generataSuggestion(search: String, completion: @escaping([Suggestion]) -> ()) {
        DispatchQueue.main.async {
            switch self.engine.type {
            case .amazon:           break
            case .duckDuckGo:       break
            case .google:           self.googleSuggestion(for: search, completion: completion)
            case .twitter:          break
            case .wikipedia:        break
            case .none:             return
            }
        }
    }
    
    func googleSuggestion(for search: String, completion: @escaping([Suggestion]) -> ()) {
        let convertedString = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let queryString = convertedString, !queryString.isEmpty else {
            return
        }
        guard let url = URL(string: "https://suggestqueries.google.com/complete/search?output=firefox&q=" + queryString) else {
            return
        }
        fetchJSON(from: url) { (json) in
            guard let result = json as? [AnyObject] else {
                return
            }
            guard let array = result.last as? [String] else {
                return
            }
            
            let phrases = array.prefix(5)
            var suggestions = [Suggestion]()
            
            for (index, title) in phrases.enumerated() {
                guard let url = self.engine.url(for: title) else {
                    return
                }
                let suggestion = Suggestion(title: title, url: url)
                suggestions.append(suggestion)
            }
            
            if !suggestions.isEmpty {
                completion(suggestions)
            }
        }
    }
    
    private func fetchJSON(from url: URL, completion: @escaping(Any?) ->()) {
        fetch(url) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data)
            completion(json)
        }
    }
    
    private func fetch(_ url: URL, completion: @escaping(Data?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completion(nil)
                return
            }
            completion(data)
        }
        task.resume()
    }
}

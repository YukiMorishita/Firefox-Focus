//
//  Suggestion.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/23.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

class Suggestion {
    let title: String?
    let url: URL
    
    init(title: String?, url: URL) {
        self.title = title
        self.url = url
    }
}

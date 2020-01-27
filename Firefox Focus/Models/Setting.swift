//
//  Setting.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/19.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

struct Setting {
    
    enum CellStyle {
        case normal
        case custom
    }
    
    enum AccessoryType {
        case none
        case stateSwitch
        case disclosureIndicator
    }
    
    let title: String
    let description: String
    let cellStyle: CellStyle
    let accessoryType: AccessoryType
    
    init(title: String, description: String, cellStyle: CellStyle, accessoryType: AccessoryType) {
        self.title = title
        self.description = description
        self.cellStyle = cellStyle
        self.accessoryType = accessoryType
    }
}

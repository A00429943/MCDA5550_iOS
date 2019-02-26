//
//  Globals.swift
//  GetGoingClass
//
//  Created by Simon Achkar on 2/21/19.
//  Copyright © 2019 SMU. All rights reserved.
//

import Foundation

enum RankBy {
    case prominence, distance
    
    func description() -> String {
        switch self {
        case .distance:
            return String(describing: self).capitalized
        case .prominence:
            return String(describing: self).capitalized
        }
    }
}

class Globals {
    // Global Variables and defaults for filtering
    
    static let rankByDictionary: [RankBy] = [.prominence, .distance]
    
    static let radiusDefault: Int = 10000;
    static let onlyOpenNowDefault: Bool = false;
    static let rankByDefault: String = RankBy.prominence.description()
    
    static var radius: Int = radiusDefault
    static var onlyOpenNow: Bool = onlyOpenNowDefault
    static var rankBy: String = rankByDefault
}



//
//  ProjectTwo_Data_Tile.swift
//  Personal_PlayGrounds
//
//  Created by UNDaniel on 22/3/20.
//  Copyright © 2020 UNDaniel. All rights reserved.
//

import Foundation

enum Tile: Int, Decodable {
    case nothing = 0
    case wall = 1
}

extension Tile {
    var isWall: Bool {
        switch self {
        case .wall: return true
        case .nothing: return false
        }
    }
}

struct Tilemap: Decodable {
    let width: Int
    let tiles: [Tile]

    subscript(x: Int, y: Int) -> Tile {
        tiles[y*width + x]
    }

    var height: Int {
        tiles.count / width
    }
}

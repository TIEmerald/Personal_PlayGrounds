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

extension Tilemap {
    func hitTest(_ ray: Ray) -> Vector {
        var position = ray.origin
        repeat {
            var edgeDistanceX: Double
            var edgeDistanceY: Double
            
            if ray.direction.x > 0 {
                edgeDistanceX = position.x.rounded(.down) + 1 - position.x
            } else {
                edgeDistanceX = position.x.rounded(.up) - 1 - position.x
            }
            if ray.direction.y > 0 {
                edgeDistanceY = position.y.rounded(.down) + 1 - position.y
            } else {
                edgeDistanceY = position.y.rounded(.up) - 1 - position.y
            }
            
            let slope = ray.direction.x / ray.direction.y
            let horizontalDelta = Vector(x: edgeDistanceX, y: edgeDistanceX / slope)
            let verticalDelta = Vector(x: edgeDistanceY * slope, y: edgeDistanceY)
            if horizontalDelta.length < verticalDelta.length {
                position += horizontalDelta
            } else {
                position += verticalDelta
            }
        } while !self.tile(at: position, direction: ray.direction).isWall
        return position
    }
}

extension Tilemap {
    func tile(at position: Vector, direction: Vector) -> Tile {
        let x = Int(position.x)
        let y = Int(position.y)
        if position.x.rounded() == position.x {
            return self[direction.x > 0 ? x : x - 1, y]
        } else {
            return self[x, direction.y > 0 ? y : y - 1]
        }
    }
}

struct Ray {
    var origin: Vector
    var direction: Vector
}

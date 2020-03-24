//
//  ProjectTwo_Data_Player.swift
//  Personal_PlayGrounds
//
//  Created by UNDaniel on 9/3/20.
//  Copyright © 2020 UNDaniel. All rights reserved.
//

import Foundation

struct Player {
    var position: Vector
    var velocity: Vector = Vector(x: 0, y: 0)
    var direction: Vector
    let radius: Double = 0.25
    let speed: Double = 2

    func intersection(with map: Tilemap) -> Vector? {
        let playerRect = self.rect
        let rect = self.rect
        let minX = Int(rect.min.x)
        let minY = Int(rect.min.y)
        let maxX = Int(rect.max.x)
        let maxY = Int(rect.max.y)
        var largestIntersection: Vector?
        for y in minY...maxY { // This nested for-loop may look expensive, but in practice, it never looks at more than four tiles.
            for x in minX...maxX {
                let min = Vector(x: Double(x), y: Double(y))
                let wallRect = Rect(min: min, max: min + Vector(x: 1, y: 1))
                if map[x, y].isWall, let intersection = wallRect.intersection(with: playerRect) {
                    if intersection.length > (largestIntersection?.length ?? 0) {
                        largestIntersection = intersection
                    }
                }
            }
        }
        return largestIntersection
    }

    mutating func update(timestep: Double, input: Vector) {
        if input.length > 0 {
            direction = input / input.length
        }
        position += velocity * timestep
        velocity = input * speed
        position += velocity * timestep
        position.x.formTruncatingRemainder(dividingBy: 8) // todo
        position.y.formTruncatingRemainder(dividingBy: 8) // todo
    }

    var rect: Rect {
        let half = Vector(x: radius, y: radius)
        return Rect(min: position - half, max: position + half)
    }
}

struct Vector {
    var x: Double
    var y: Double
    
    var orthogonal: Vector {
        Vector(x: -y, y: x)
    }
}

extension Vector {
    var length: Double {
        (x*x + y*y).squareRoot()
    }
}

extension Vector {
    static func +(lhs: Vector, rhs: Vector) -> Vector {
        return Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func - (lhs: Vector, rhs: Vector) -> Vector {
        return Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func * (lhs: Vector, rhs: Double) -> Vector {
        return Vector(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    static func / (lhs: Vector, rhs: Double) -> Vector {
        return Vector(x: lhs.x / rhs, y: lhs.y / rhs)
    }

    static func * (lhs: Double, rhs: Vector) -> Vector {
        return Vector(x: lhs * rhs.x, y: lhs * rhs.y)
    }

    static func / (lhs: Double, rhs: Vector) -> Vector {
        return Vector(x: lhs / rhs.x, y: lhs / rhs.y)
    }

    static func += (lhs: inout Vector, rhs: Vector) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    static func -= (lhs: inout Vector, rhs: Vector) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }

    static func *= (lhs: inout Vector, rhs: Double) {
        lhs.x *= rhs
        lhs.y *= rhs
    }

    static func /= (lhs: inout Vector, rhs: Double) {
        lhs.x /= rhs
        lhs.y /= rhs
    }

    static prefix func - (rhs: Vector) -> Vector {
        return Vector(x: -rhs.x, y: -rhs.y)
    }
}

struct Rect {
    var min: Vector
    var max: Vector
}

extension Rect {
    static func * (lhs: Rect, rhs: Double) -> Rect {
        return Rect(min: lhs.min * rhs, max: lhs.max * rhs)
    }

    static func * (lhs: Double, rhs: Rect) -> Rect {
        return Rect(min: rhs.min * lhs, max: rhs.max * lhs)
    }
}

extension Rect {
    func intersection(with other: Rect) -> Vector? {
        var checkingVect = [Vector]()
        let left = Vector(x: max.x - other.min.x, y: 0)
        if left.x > 0 { checkingVect.append(left) } // If self.max.x > other.min.x which means I am overlap with other, and I want to push it to (+x)right
        let right = Vector(x: min.x - other.max.x, y: 0)
        if right.x < 0 { checkingVect.append(right) } // If self.min.x < other.max.x which means I am overlap with other, and I want to push it to (-x)left
        let top = Vector(x: 0, y: max.y - other.min.y)
        if top.y > 0 { checkingVect.append(top) } // If self.max.y > other.min.y which means I am overlap with other, and I want to push it to (+y)down
        let bottom = Vector(x: 0, y: min.y - other.max.y)
        if bottom.y < 0 { checkingVect.append(bottom) } // If self.min.y < other.max.y which means I am overlap with other, and I want to push it to (-y)up
        return checkingVect.sorted(by: { $0.length < $1.length }).first // We will move it back to the shortest back vect
    }
}

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
    var velocity: Vector
    let radius: Double = 0.5
    
    mutating func update(timestep: Double) {
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

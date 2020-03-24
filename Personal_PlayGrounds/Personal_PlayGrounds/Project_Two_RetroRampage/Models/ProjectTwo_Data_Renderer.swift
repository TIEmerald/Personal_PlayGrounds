//
//  ProjectTwo_Data_Renderer.swift
//  Personal_PlayGrounds
//
//  Created by UNDaniel on 9/3/20.
//  Copyright © 2020 UNDaniel. All rights reserved.
//

import Foundation

struct PTwoColor {
    var r, g, b: UInt8
    var a: UInt8 = 255
}

extension PTwoColor {
    static let clear = PTwoColor(r: 0, g: 0, b: 0, a: 0)
    static let black = PTwoColor(r: 0, g: 0, b: 0)
    static let white = PTwoColor(r: 255, g: 255, b: 255)
    static let gray = PTwoColor(r: 192, g: 192, b: 192)
    static let red = PTwoColor(r: 255, g: 0, b: 0)
    static let green = PTwoColor(r: 0, g: 255, b: 0)
    static let blue = PTwoColor(r: 0, g: 0, b: 255)
}

struct Bitmap {
    let width: Int
    var pixels: [PTwoColor]

    var height: Int {
        pixels.count / width
    }

    init(width: Int, height: Int, color: PTwoColor) {
        self.width = width
        pixels = Array(repeating: color, count: width * height)
    }

    subscript(x: Int, y: Int) -> PTwoColor {
        get {
            guard y < height, x < width, y >= 0, x >= 0 else { fatalError() }
            return pixels[y * width + x]
        }
        set {
            guard y < height, x < width, y >= 0, x >= 0 else { return }
            pixels[y * width + x] = newValue
        }
    }
}

extension Bitmap {
    mutating func fill(rect: Rect, color: PTwoColor) {
        for y in Int(rect.min.y)..<Int(rect.max.y) {
            for x in Int(rect.min.x)..<Int(rect.max.x) {
                self[x, y] = color
            }
        }
    }

    mutating func drawLine(from: Vector, to: Vector, color: PTwoColor) {
        let difference = to - from
        let stepCount: Int
        let step: Vector
        if abs(difference.x) > abs(difference.y) {
            stepCount = Int(abs(difference.x).rounded(.up))
            let sign: Double = difference.x > 0 ? 1 : -1
            step = Vector(x: 1, y: difference.y/difference.x) * sign
        } else {
            stepCount = Int(abs(difference.y).rounded(.up))
            let sign: Double = difference.y > 0 ? 1 : -1
            step = Vector(x: difference.x/difference.y, y: 1) * sign
        }
        var position = from
        for _ in 0..<stepCount {
            self[Int(position.x), Int(position.y)] = color
            position += step
        }
    }
}

struct Renderer {
    var bitmap = Bitmap(width: 8, height: 8, color: .black)

    init(width: Int, height: Int) {
        bitmap = Bitmap(width: width, height: height, color: .black)
    }

    mutating func draw(world: World) {
        let worldWidth = world.map.width
        let scale = Double(bitmap.width) / Double(worldWidth)
        let focalLength = 1.0
        let planeWidth = 1.0

        // Word
        for y in 0..<world.map.height {
            for x in 0..<world.map.width {
                guard world.map[x, y].isWall else { continue }
                let min = Vector(x: Double(x) * scale, y: Double(y) * scale)
                let rect = Rect(
                    min: min,
                    max: min + Vector(x: scale, y: scale)
                )
                bitmap.fill(rect: rect, color: .white)
            }
        }

        // Players
        bitmap.fill(rect: world.player.rect * scale, color: .blue)
        
        // View Rays
        let viewCenter = world.player.position + world.player.direction * focalLength
        let viewStart = viewCenter - world.player.direction.orthogonal * planeWidth / 2
        var position = viewStart
        let columns = 10
        let step = world.player.direction.orthogonal * planeWidth / Double(columns)
        for _ in 0..<columns {
            let end = position - world.player.position
            let ray = Ray(
                origin: world.player.position,
                direction: end / end.length
            )
            let lineEnd = world.map.hitTest(ray) * scale
            bitmap.drawLine(from: world.player.position * scale, to: lineEnd, color: .green)
            position += step
        }
    }
}

struct Renderer3D {
    
    var bitmap = Bitmap(width: 8, height: 8, color: .black)
    
    init(width: Int, height: Int) {
        bitmap = Bitmap(width: width, height: height, color: .black)
    }
    
    mutating func draw(world: World) {
        let focalLength = 1.0
        let planeWidth = 1.0
        
        // View Rays
        let viewCenter = world.player.position + world.player.direction * focalLength
        let viewStart = viewCenter - world.player.direction.orthogonal * planeWidth / 2
        var position = viewStart
        let columns = bitmap.width
        let step = world.player.direction.orthogonal * planeWidth / Double(columns)
        for column in 0..<columns {
            let end = position - world.player.position
            let ray = Ray(
                origin: world.player.position,
                direction: end / end.length
            )
            let wallIntersection = world.map.hitTest(ray)
            position += step
            
            let wallHeight = 1.0
            let wallDistance = wallIntersection - world.player.position
            let height = focalLength * wallHeight / wallDistance.length * Double(bitmap.height)
            
            let wallStart = Vector(x: Double(column), y: Double(bitmap.height) / 2 - height / 2)
            let wallEnd = Vector(x: Double(column), y: Double(bitmap.height) / 2 + height / 2)
            bitmap.drawLine(from: wallStart, to: wallEnd, color: .white)
        }
    }
}

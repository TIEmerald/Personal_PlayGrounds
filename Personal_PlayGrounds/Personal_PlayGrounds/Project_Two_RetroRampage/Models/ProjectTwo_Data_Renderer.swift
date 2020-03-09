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
}

struct Renderer {
    var bitmap = Bitmap(width: 8, height: 8, color: .white)
    
    init(width: Int, height: Int) {
        bitmap = Bitmap(width: width, height: height, color: .white)
    }
    
    mutating func draw(player: Player) {
        let worldWidth = 8.0
        let worldHeight = 8.0
        let scale = Double(bitmap.width) / worldWidth
        bitmap.fill(rect: player.rect * scale, color: .blue)
    }
}

//
//  ProjectTwo_Data_World.swift
//  Personal_PlayGrounds
//
//  Created by UNDaniel on 22/3/20.
//  Copyright © 2020 UNDaniel. All rights reserved.
//

import Foundation

struct World {
    var player: Player
    var map: Tilemap

    mutating func update(timestep: Double, input: Vector) {
        player.update(timestep: timestep, input: input)
        if let intersection = player.intersection(with: map) {
            player.position += intersection
        }
    }
}

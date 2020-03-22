//
//  ProjectOne_Data_Stopwatch.swift
//  Personal_PlayGrounds
//
//  Created by UNDaniel on 8/3/20.
//  Copyright © 2020 UNDaniel. All rights reserved.
//

import Foundation

enum LapType {
    case regular
    case shortest
    case longest
}

struct StopwatchData {
    var absoluteStartTime: TimeInterval?
    var currentTime: TimeInterval = 0
    var additionalTime: TimeInterval = 0
    var lastLapEnd: TimeInterval = 0
    var _laps: [(TimeInterval, LapType)] = []
    var laps: [(TimeInterval, LapType)] {
        guard totalTime > 0 else { return [] }
        return _laps + [(currentLapTime, .regular)]
    }

    var currentLapTime: TimeInterval {
        totalTime - lastLapEnd
    }

    var totalTime: TimeInterval {
        guard let start = absoluteStartTime else { return additionalTime }
        return additionalTime + currentTime - start
    }

    mutating func lap() {
        let lapTimes = _laps.map { $0.0 } + [currentLapTime]
        if let shortest = lapTimes.min(), let longest = lapTimes.max(), shortest != longest {
            _laps = lapTimes.map { ($0, $0 == shortest ? .shortest : ($0 == longest ? .longest : .regular ))}
        } else {
            _laps = lapTimes.map { ($0, .regular) }
        }
        lastLapEnd = totalTime
    }

    mutating func start(at time: TimeInterval) {
        currentTime = time
        absoluteStartTime = time
    }

    mutating func stop() {
        additionalTime = totalTime
        absoluteStartTime = nil
    }
}

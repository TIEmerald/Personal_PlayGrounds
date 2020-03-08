//
//  ProjectOne_View_ClockView.swift
//  Personal_PlayGrounds
//
//  Created by UNDaniel on 8/3/20.
//  Copyright © 2020 UNDaniel. All rights reserved.
//

import SwiftUI

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
    
    init(center: CGPoint, radius: CGFloat) {
        self = CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        )
    }
}

struct Pointer: Shape {
    var circleRadius: CGFloat = 3
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.midY - circleRadius))
            p.addEllipse(in: CGRect(center: rect.center, radius: circleRadius))
            p.move(to: CGPoint(x: rect.midX, y: rect.midY + circleRadius))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.midY + rect.height / 10))
        }
    }
}
struct Clock: View {
    var time: TimeInterval = 10
    var lapTime: TimeInterval?
    
    func tick(at tick: Int) -> some View {
        VStack {
            Rectangle()
                .fill(Color.primary)
                .opacity(tick % 20 == 0 ? 1 : 0.4)
                .frame(width: 2, height: tick % 4 == 0 ? 15 : 7)
            Spacer()
        }
        .rotationEffect(Angle.degrees(Double(tick)/240 * 360))
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<240) { tick in
                self.tick(at: tick)
            }
            if lapTime != nil {
                Pointer()
                    .stroke(Color.blue, lineWidth: 2)
                    .rotationEffect(Angle.degrees(Double(lapTime!) * 360/60))
            }
            Pointer()
                .stroke(Color.orange, lineWidth: 2)
                .rotationEffect(Angle.degrees(Double(time) * 360/60))
            Color.clear
        }
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        Clock()
            .background(Color.white)
            .previewLayout(.fixed(width: 300, height: 300))
    }
}

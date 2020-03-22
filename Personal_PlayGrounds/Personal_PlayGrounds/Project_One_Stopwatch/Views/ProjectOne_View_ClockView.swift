//
//  ProjectOne_View_ClockView.swift
//  Personal_PlayGrounds
//
//  Created by UNDaniel on 8/3/20.
//  Copyright © 2020 UNDaniel. All rights reserved.
//

import SwiftUI

extension CGPoint {
    init(angle: Angle, distance: CGFloat) {
        self = CGPoint(x: CGFloat(cos(angle.radians)) * distance, y: CGFloat(sin(angle.radians)) * distance)
    }

    var size: CGSize {
        CGSize(width: x, height: y)
    }
}

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

struct Labels: View {
    var labels: [Int]

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(self.labels.indices) { idx in
                    Text("\(self.labels[idx])")
                        .offset(CGPoint(angle: .degrees(360 * Double(idx)/Double(self.labels.count) - 90), distance: proxy.size.width/2).size)
                }
            }
        }
    }
}

struct Ticks: View {
    var majorTicks: Int
    var subdivisions: Int
    var majorHeight: CGFloat = 15
    var totalTicks: Int { majorTicks * subdivisions }

    func tick(at tick: Int) -> some View {
        VStack {
            Rectangle()
                .fill(Color.primary)
                .opacity(tick % (5 * subdivisions) == 0 ? 1 : 0.4)
                .frame(width: 2, height: tick % subdivisions == 0 ? majorHeight : majorHeight/2)
            Spacer()
        }.rotationEffect(Angle.degrees(Double(tick)/Double(totalTicks) * 360))
    }

    var body: some View {
        ForEach(0..<totalTicks) { tick in
            self.tick(at: tick)
        }
    }
}

struct Clock: View {
    var time: TimeInterval = 10
    var lapTime: TimeInterval?

    var body: some View {
        ZStack {
            Ticks(majorTicks: 60, subdivisions: 4)
            Labels(labels: [60] + stride(from: 5, through: 55, by: 5))
                .padding(40)
                .font(.title)
            ZStack {
                Ticks(majorTicks: 30, subdivisions: 2, majorHeight: 10)
                Labels(labels: [30] + stride(from: 5, through: 25, by: 5))
                    .padding(20)
                Pointer()
                    .stroke(Color.orange, lineWidth: 1.5)
                    .rotationEffect(Angle.degrees(Double(time) * 360/(60*30)))
            }
            .frame(width: 90, height: 90)
            .offset(y: -50)
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
        .aspectRatio(1, contentMode: .fit)
    }
}

struct ClockView_ClockView_Previews: PreviewProvider {
    static var previews: some View {
        Clock()
            .background(Color.white)
            .previewLayout(.fixed(width: 300, height: 300))
    }
}

//
//  ContentView.swift
//  Personal_PlayGrounds
//
//  Created by UNDaniel on 22/2/20.
//  Copyright © 2020 UNDaniel. All rights reserved.
//

import SwiftUI

/// Ensure formatters are not created every time it be called.
let formatter: DateComponentsFormatter = {
    let f = DateComponentsFormatter()
    f.allowedUnits = [.minute, .second]
    f.zeroFormattingBehavior = .pad
    return f
}()
let numberFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.minimumFractionDigits = 2
    f.maximumFractionDigits = 2
    f.maximumIntegerDigits  = 0
    f.alwaysShowsDecimalSeparator = true
    return f
}()

final class Stopwatch: ObservableObject {
    @Published private var data = StopwatchData()
    private var timer: Timer?
    
    var total: TimeInterval {
        data.totalTime
    }
    
    var isRunning: Bool {
        data.absoluteStartTime != nil
    }
    
    var laps: [(TimeInterval, LapType)] { data.laps }
    
    func lap() {
        data.lap()
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] timer in
            self.data.currentTime = Date().timeIntervalSinceReferenceDate
        })
        data.start(at: Date().timeIntervalSinceReferenceDate)
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        data.stop()
    }
    
    func reset() {
        stop()
        data = StopwatchData()
    }
    
    deinit {
        stop()
    }
}

extension TimeInterval {
    var formatted: String {
        let ms = self.truncatingRemainder(dividingBy: 1)
        return formatter.string(from: self)! + numberFormatter.string(from: NSNumber(value: ms))!
    }
}

extension LapType {
    var color: Color {
        switch self {
        case .regular:
            return .black
        case .shortest:
            return .green
        case .longest:
            return .red
        }
    }
}

extension View {
    
    func visible(_ v: Bool) -> some View {
        self.opacity(v ? 1 : 0)
    }
    
    func equalSize() -> some View {
        self.modifier(EqualSize())
    }
    
    func equalSizes() -> some View {
        self.modifier(EqualSizes())
    }
    
}

struct SizeKey: PreferenceKey {
    static let defaultValue: [CGSize] = []
    static func reduce(value: inout [CGSize], nextValue: () -> [CGSize]) {
        value.append(contentsOf: nextValue())
    }
}

struct SizeEnvironmentKey: EnvironmentKey {
    static let defaultValue: CGSize? = nil
}

extension EnvironmentValues {
    var size: CGSize? {
        get { self[SizeEnvironmentKey.self] }
        set { self[SizeEnvironmentKey.self] = newValue }
    }
}

fileprivate struct EqualSize: ViewModifier {
    @Environment(\.size) private var size
    func body(content: Content) -> some View {
        content
            .overlay(GeometryReader { proxy in
                Color.clear.preference(key: SizeKey.self, value: [proxy.size])
            })
            .frame(width: size?.width, height: size?.width)
    }
}

fileprivate struct EqualSizes: ViewModifier {
    @State var width: CGFloat?
    func body(content: Content) -> some View {
        content
            .onPreferenceChange(SizeKey.self, perform: { sizes in
                self.width = sizes.map { $0.width }.max()
            })
            .environment(\.size, width.map{ CGSize(width: $0, height: $0) })
    }
}

struct ButtonCircle: ViewModifier {
    
    let isPressed: Bool
    @State var size: CGSize? = nil
    
    func body(content: Content) -> some View {
        let background = Circle()
            .fill()
            .overlay(
                Circle()
                    .fill(Color.white)
                    .opacity(isPressed ? 0.3 : 0))
            .overlay(
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.white)
                    .padding(4))
        
        let foreground = content
            .fixedSize()
            .padding(15)
            .equalSize()
            .foregroundColor(.white)
        
        return foreground
            .frame(width: size?.width, height: size?.width)
            .background(background)
    }
}

struct CircleStyle: ButtonStyle {
    
    @State var size: CGSize? = nil
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label.modifier(ButtonCircle(isPressed: configuration.isPressed))
        
    }
}

struct ProjectOneContentView: View {
    
    @ObservedObject var stopwatch = Stopwatch()
    
    var body: some View {
        VStack {
            Clock(time: stopwatch.total, lapTime: stopwatch.laps.last?.0)
            Text(stopwatch.total.formatted)
                .flexible({ Font.system(size: $0, weight: .thin).monospacedDigit() })
            HStack {
                ZStack {
                    Button(action: { self.stopwatch.lap() }) {
                        Text("Lap")
                    }
                    .foregroundColor(.gray)
                    .visible(stopwatch.isRunning)
                    Button(action: { self.stopwatch.reset() }) {
                        Text("Reset")
                    }
                    .foregroundColor(.gray)
                    .visible(!stopwatch.isRunning)
                }
                Spacer()
                ZStack {
                    Button(action: { self.stopwatch.stop() }) {
                        Text("Stop")
                    }
                    .foregroundColor(.red)
                    .visible(stopwatch.isRunning)
                    Button(action: { self.stopwatch.start() }) {
                        Text("Start")
                    }
                    .foregroundColor(.green)
                    .visible(!stopwatch.isRunning)
                }
            }
            .equalSizes()
            .padding(.horizontal)
            .buttonStyle(CircleStyle())
            List {
                ForEach(stopwatch.laps.enumerated().reversed(), id: \.offset) { value in
                    HStack {
                        Text("Lap \(value.offset + 1)")
                        Spacer()
                        Text(value.element.0.formatted)
                            .font(Font.body.monospacedDigit())
                    }
                    .foregroundColor(value.element.1.color)
                }
            }
        }
    }
}

struct ProjectOneContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectOneContentView()
    }
}

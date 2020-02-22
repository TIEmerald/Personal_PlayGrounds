//
//  ContentView.swift
//  Personal_PlayGrounds
//
//  Created by UNDaniel on 22/2/20.
//  Copyright © 2020 UNDaniel. All rights reserved.
//

import SwiftUI

struct SizeEnvironmentKey: EnvironmentKey {
    static let defaultValue: CGSize? = nil
}

extension EnvironmentValues {
    var size: CGSize? {
        get { self[SizeEnvironmentKey.self] }
        set { self[SizeEnvironmentKey.self] = newValue }
    }
    
}

extension View {
    
    func equalSize() -> some View {
        self.modifier(EqualSize())
    }
    
    func equalSizes() -> some View {
        self.modifier(EqualSizes())
    }
    
}

struct ProjectOneContentView: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                Text("Reset")
            }
            .foregroundColor(.red)
            
            Button(action: {}) {
                Text("Start New")
            }
            .foregroundColor(.green)
        }
        .equalSizes()
        .padding()
        .buttonStyle(CircleStyle())
    }
}

struct SizeKey: PreferenceKey {
    static let defaultValue: [CGSize] = []
    static func reduce(value: inout [CGSize], nextValue: () -> [CGSize]) {
        value.append(contentsOf: nextValue())
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

struct ProjectOneContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectOneContentView()
    }
}

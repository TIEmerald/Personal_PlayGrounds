//
//  ContentView.swift
//  Personal_PlayGrounds
//
//  Created by UNDaniel on 22/2/20.
//  Copyright © 2020 UNDaniel. All rights reserved.
//

import SwiftUI

struct ProjectOneContentView: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                Text("Stop")
            }
            .foregroundColor(.red)
            .frame(width: 75, height: 75, alignment: .center)
            
            Button(action: {}) {
                Text("Start")
            }
            .foregroundColor(.green)
            .frame(width: 75, height: 75, alignment: .center)
        }
        .padding()
        .buttonStyle(CircleStyle())
    }
}

struct CircleStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Circle()
            .fill()
            .overlay(
                Circle()
                    .fill(Color.white)
                    .opacity(configuration.isPressed ? 0.3 : 0))
            .overlay(
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.white)
                    .padding(4))
            .overlay(
                configuration.label
                    .foregroundColor(.white))
    }
}

struct ProjectOneContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectOneContentView()
    }
}

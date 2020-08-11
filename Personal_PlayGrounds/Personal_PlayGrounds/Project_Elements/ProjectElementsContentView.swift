//
//  ProjectElementsView.swift
//  Personal_PlayGrounds
//
//  Created by UNDaniel on 11/8/20.
//  Copyright © 2020 UNDaniel. All rights reserved.
//

import SwiftUI

struct ProjectElementsContentView: View {
    
    @State private var circleColorChanged = false
    @State private var heartColorChanged = false
    @State private var heartSizeChanged = false
    
    @State private var isLoading = false
    
    var body: some View {
        ScrollView {
            ZStack {
                Circle()
                    .frame(width: 200, height: 200)
                    .foregroundColor(circleColorChanged ? Color(.systemGray5) : .red)
                
                Image(systemName: "heart.fill")
                    .foregroundColor(heartColorChanged ? .red : .white)
                    .font(.system(size: 100))
                    .scaleEffect(heartSizeChanged ? 1.0 : 0.5)
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0.3)) {
                    self.circleColorChanged.toggle()
                    self.heartColorChanged.toggle()
                    self.heartSizeChanged.toggle()
                }
            }
            
            ZStack {
                
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 14)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: 0.2)
                    .stroke(Color.green, lineWidth: 7)
                    .frame(width: 100, height: 100)
                    .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .onAppear() {
                        self.isLoading = true
                }
            }
            ZStack {
                
                Text("Loading")
                    .font(.system(.body, design: .rounded))
                    .bold()
                
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color(.systemGray5), lineWidth: 3)
                    .frame(width: 250, height: 3)
                    .offset(x: 0, y: 25)
                
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.green, lineWidth: 3)
                    .frame(width: 30, height: 3)
                    .offset(x: isLoading ? 110 : -110, y: 0)
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .offset(x: 0, y: 25)
            }
            .onAppear() {
                self.isLoading = true
            }
        }
    }
}

struct ProjectElementsContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectElementsContentView()
    }
}

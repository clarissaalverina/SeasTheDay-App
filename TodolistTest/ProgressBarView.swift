//
//  ProgressBarView.swift
//  TodolistTest
//
//  Created by Clarissa Alverina on 24/06/24.
//

import SwiftUI

struct ProgressBarView: View {
    @Binding var maxTaps: Int
    @Binding var progress: Double
    let progressBarHeight: CGFloat = 12
    let progressBarWidth: CGFloat = 150
    let cornerRadius: CGFloat = 10

    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: progressBarWidth, height: progressBarHeight)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .cornerRadius(cornerRadius)

                Rectangle()
                    .frame(width: CGFloat(progress / Double(maxTaps)) * progressBarWidth, height: progressBarHeight)
                    .foregroundColor(Color(hex: 0xFBAC01))
                    .cornerRadius(cornerRadius)
            }

//            Button(action: {
//                if progress < Double(maxTaps) {
//                    progress += 1
//                }
//            }) {
//                Text("Tap me")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
//
//            Text("Taps: \(Int(progress)) / \(maxTaps)")
        }
        .padding()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressBarView()
//    }
//}

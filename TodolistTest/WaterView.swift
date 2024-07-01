//
//  WaterView.swift
//  MetalTest
//
//  Created by Clarissa Alverina on 20/06/24.
//

import SwiftUI
import Lottie

struct WaterView: View {
    @State private var start = Date.now
//    @State private var moveToTop = false
//    @State private var isFloating = false
//    @State private var returnToInitial = false
//    @State private var backgroundOffset: CGFloat = 0
//    @State private var componentFloating = false
    @Binding var moveToTop: Bool
    @Binding var isFloating: Bool
    @Binding var returnToInitial: Bool
    @Binding var backgroundOffset: CGFloat
    @Binding var componentFloating: Bool
    @State private var companionAnimation = false
    @Binding var treasureOpen: Bool
    

    var body: some View {
        TimelineView(.animation) { tl in
            let time = start.distance(to: tl.date)
            ZStack {
                VStack {
                    VStack {
                        BackgroundImageView(imageName: "sea bg 2")
                            .offset(y: backgroundOffset)
                    }
                    VStack {
                        BackgroundImageView(imageName: "sea bg")
                            .offset(y: backgroundOffset)
                    }
                }
                
                BackgroundImageView2(imageName: "water")
                    .offset(y: backgroundOffset)
                    .opacity(0.3)
                    .visualEffect { content, proxy in
                        content
                            .distortionEffect(
                                ShaderLibrary.wave(
                                    .float(time),
                                    .float2(proxy.size)
                                ),
                                maxSampleOffset: .zero
                            )
                    }
                    .clipped()
                
                VStack {
                    BackgroundImageView(imageName: "sea components 2")
                        .offset(y: backgroundOffset)
                        .offset(y: componentFloating ? 3 : -3)
                    
                }
                
                ZStack {
                    VStack {
                        LottieView(animation: .named("boat tanpa shadow  (5)"))
                            .playbackMode(moveToTop ? .playing(.toProgress(2, loopMode: .loop)) : .paused)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .padding(.bottom, 320)
                            .offset(y: moveToTop ? -UIScreen.main.bounds.height / 10 : UIScreen.main.bounds.height / 8)
                            .offset(y: isFloating ? -3.5 : 3.5)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                                    isFloating.toggle()
                                    componentFloating.toggle()
                                }
                            }
                    }
                    if treasureOpen {
                        VStack {
                            Image("dog")
                                .resizable()
                                .frame(width: companionAnimation ? 75 : 500, height: companionAnimation ? 75 : 500)
                                .offset(y: isFloating ? -3.5 : 3.5)
                                .offset(y: moveToTop ? -UIScreen.main.bounds.height / 10 : UIScreen.main.bounds.height / 8)
                                .padding(.bottom, 400)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1)) {
                                        companionAnimation.toggle()
                                    }
                                }
                        }
                    }
                }
                
//                Button("Move") {
//                    withAnimation(.easeInOut(duration: 2)) {
//                        moveToTop = true
//                        returnToInitial = false
//                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        withAnimation(.easeInOut(duration: 2)) {
//                            moveToTop = false
//                            returnToInitial = true
//                            backgroundOffset += 200
//                        }
//                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
//                            isFloating.toggle()
//                            componentFloating.toggle()
//                        }
//                    }
//                }
//                .padding(.top, 500)
//                .foregroundColor(.white)
//                .bold()
//                .font(.system(size: 20))
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundImageView: View {
    let imageName: String
    
    var body: some View {
        GeometryReader { geometry in
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundImageView2: View {
    let imageName: String
    
    var body: some View {
        GeometryReader { geometry in
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                
        }
        .edgesIgnoringSafeArea(.all)
    }
}

//#Preview {
//    WaterView()
//}

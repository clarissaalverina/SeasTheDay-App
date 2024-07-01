//
//  TodoTabView.swift
//  TodolistTest
//
//  Created by Vincent Senjaya on 24/06/24.
//

import SwiftUI

struct TodoTabView: View {
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    
    let tabBarItems: [(image: String, title : String)] = [
        
        ("clock.arrow.circlepath", "History"),
        ("house", "Home"),
        ("calendar", "Schedule")
    ]
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .frame(height: 80)
                .foregroundColor(Color(.secondarySystemBackground))
                .shadow(radius: 2)
            HStack(){
                ForEach(0..<3){ index in
                    Button{
                        tabSelection = index + 1
                    } label: {
                        VStack(spacing: 8){
                            Spacer()
                            Image(systemName: tabBarItems[index].image)
                            Text(tabBarItems[index].title)
                            if index + 1 == tabSelection {
                                Capsule()
                                    .frame(height: 0)
                                    .foregroundColor(Color(hex: 0x00463D))
                                    .matchedGeometryEffect(id: "SelectedTabId", in: animationNamespace)
                                    .offset(y: 3)
                            } else {
                                Capsule()
                                    .frame(height: 0)
                                    .foregroundColor(.clear)
                                    .offset(y: 3)
                            }
                        }.foregroundColor(index + 1 == tabSelection ? Color(hex: 0x4CB4A7) : .gray)
                    }
                }
            }
            .frame(height: 48)
        }
        .frame(width: 340)
//        .padding(8)
    }
}


//#Preview {
//    TodoTabView()
//}

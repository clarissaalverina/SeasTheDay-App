//
//  ProfileView.swift
//  TodolistTest
//
//  Created by Vincent Senjaya on 24/06/24.
//

import SwiftUI
import Charts
import SwiftData

struct ProfileView: View {
    @Environment (\.dismiss) var dismiss
    @Binding var currentExp : Int
    @Binding var currentLevel : Int
    @Binding var completedTask : Int
    @Query var tasks: [Task]
    @State private var showPetSheet: Bool = false
    @Query(filter: #Predicate<Task> { task in
           task.priority == 1
       }) private var taskMeh : [Task]
       
   @Query(filter: #Predicate<Task> { task in
       task.priority == 2
   }) private var taskMaybe : [Task]
   
   @Query(filter: #Predicate<Task> { task in
       task.priority == 3
   }) private var taskMust : [Task]
    
    private var taskStats: [(name: String, count: Int)] {
           return [
               (name: "Meh", count: taskMeh.count),
               (name: "Maybe", count: taskMaybe.count),
               (name: "Must", count: taskMust.count),
           ]
       }
    let colorMapping: [String: Color] = [
            "Meh": Color(hex: 0xCF5C3C),
            "Maybe": Color(hex: 0xFBAC01),
            "Must": Color(hex: 0x98BD27)
        ]
    var body: some View {
        ZStack{
            BackgroundImageView(imageName: "sea bg").ignoresSafeArea()
            ScrollView{
                VStack(alignment: .leading) {
                    // Header
                    VStack{
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Ahoy,")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Text("Captain!")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }.foregroundColor(.black)
                            Spacer()
                            Image("captain")
                                .resizable()
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
                        }
                        // Level and XP
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("My Journey")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(hex: 0x00463D))
                                    Text("\(currentExp)/100 XP")
                                        .font(.caption)
                                        .foregroundColor(Color.gray)
                                }
                                Spacer()
                            }
                            // Statistics
                            HStack {
                                VStack {
                                    Text("\(completedTask)")
                                        .font(.headline)
                                        .foregroundColor(Color(hex: 0x00463D))
                                    Text("Finished task")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Divider()
                                Spacer()
                                VStack {
                                    Text("\(completedTask)")
                                        .font(.headline)
                                        .foregroundColor(Color(hex: 0x00463D))
                                    Text("Treasures")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Divider()
                                Spacer()
                                ZStack {
                                    Circle()
                                        .stroke(lineWidth: 10)
                                        .opacity(0.3)
                                        .foregroundColor(Color.gray)
                                    Circle()
                                        .trim(from: 0.0, to: 0.5)
                                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                                        .foregroundColor(Color(hex: 0xFBAC01))
                                        .rotationEffect(Angle(degrees: 270.0))
                                        .animation(.linear)
                                    VStack {
                                        Text("\(currentLevel)")
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(hex: 0x00463D))
                                        Text("Level")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .frame(width: 70, height: 70)
                                
                            }
                        }
                        .padding(25)
                        .background(Color.white)
                        .cornerRadius(10)
                    }.padding().background(Color(hex: 0xFBF7EF)).cornerRadius(10)
                    
                    // Pet Collection
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Pet Collection")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: 0x00463D))
                                Text("Pet you have been discovered")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack{
                                Image("pet")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    
                            }
                        }
                    }
                    .padding(25)
                    .onTapGesture {
                        showPetSheet = true
                    }
                    .background(Color(hex: 0xFBF7EF)).cornerRadius(10)
                    
                    // Task Progress
                    VStack(alignment: .center) {
                        Text("Your Weekly Summary")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: 0x00463D))
                        HStack{
                            VStack {
                                ZStack{
                                    Circle()
                                        .fill(Color.white)
                                    Chart {
                                        ForEach(taskStats, id: \.name) { coffee in
                                            SectorMark(
                                                angle: .value("Cup", coffee.count),
                                                innerRadius: .ratio(0.65),
                                                angularInset: 2.0
                                            )
                                            .foregroundStyle(colorMapping[coffee.name] ?? .gray)
                                            .cornerRadius(10)
                                        }
                                    }.chartLegend(.hidden).padding()
                                }
                            }
                            VStack(alignment: .leading) {
                                HStack {
                                    Circle().fill(Color(hex: 0xCF5C3C)).frame(width: 15, height: 15)
                                    VStack(alignment: .leading)
                                    {
                                        Text("health").font(.system(size: 16)).foregroundColor(Color(hex: 0x00463D))
                                        Text("\(taskMeh.count) task").font(.system(size: 12)).opacity(0.5).foregroundColor(Color(hex: 0x00463D))
                                    }
                                }
                                
                                HStack {
                                    Circle().fill(Color(hex: 0xFBAC01)).frame(width: 15, height: 15)
                                    VStack(alignment: .leading)
                                    {
                                        Text("work").font(.system(size: 16)).foregroundColor(Color(hex: 0x00463D))
                                        Text("\(taskMaybe.count) task").font(.system(size: 12)).opacity(0.5).foregroundColor(Color(hex: 0x00463D))
                                    }
                                }
                                
                                HStack {
                                    Circle().fill(Color(hex: 0x98BD27)).frame(width: 15, height: 15)
                                    VStack(alignment: .leading)
                                    {
                                        Text("house").font(.system(size: 16)).foregroundColor(Color(hex: 0x00463D))
                                        Text("\(taskMust.count) task").font(.system(size: 12)).opacity(0.5).foregroundColor(Color(hex: 0x00463D))
                                    }
                                }
                            }.padding()
                        }
                    }.padding(25)
                        .background(Color(hex: 0xFBF7EF)).cornerRadius(10)
                    
                    
                    VStack {
                        HStack {
                            Button{
                                self.dismiss()
                            } label: {
                                Spacer()
                                Text("Okay!").font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: 0xFBF7EF))
                                Spacer()
                            }
                            
                        }
                        
                    }
                    .padding(25)
                    .background(Color(hex: 0x4CB4A7)).cornerRadius(10)
                    
                }
                
            }.padding().edgesIgnoringSafeArea(.bottom)
        }
        .sheet(isPresented: $showPetSheet) {
            ZStack {
                VStack(alignment: .center, spacing: 10) {
                    ScrollView{
                        Text("Pet Collection").font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: 0x00463D))
                        Text("Select one to accompany you on your boat.").font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: 0x00463D))
                        HStack{
                            ZStack{
                                Color.white.frame(width: 110, height: 110)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                                    .shadow(radius: 3)
                                Image("duck")
                                    .resizable()
                                    .frame(width: 110, height: 110)
                            }
                
                            ZStack{
                                Color.white.frame(width: 110, height: 110)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                                    .shadow(radius: 3)
                                Image("dog")
                                    .resizable()
                                    .frame(width: 110, height: 110)
                            }
                            ZStack{
                                Color.white.frame(width: 110, height: 110)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                                    .shadow(radius: 3)
                                Image("otter")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }.padding()
                        HStack{
                            ZStack{
                                Color.white.frame(width: 110, height: 110)
                                Image(systemName: "lock.square")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                
                                    .foregroundColor(.gray)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                            }.frame(height:110).cornerRadius(20).shadow(radius: 5)
                            ZStack{
                                Color.white.frame(width: 110, height: 110)
                                Image(systemName: "lock.square")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .foregroundColor(.gray)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                            }.frame(height:110).cornerRadius(20).shadow(radius: 5)
                            ZStack{
                                Color.white.frame(width: 110, height: 110)
                                Image(systemName: "lock.square")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .foregroundColor(.gray)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                            }.frame(height:110).cornerRadius(20).shadow(radius: 5)
                        }.padding()
                        
                        HStack{
                            ZStack{
                                Color.white.frame(width: 110, height: 110)
                                Image(systemName: "lock.square")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                
                                    .foregroundColor(.gray)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                            }.frame(height:110).cornerRadius(20).shadow(radius: 5)
                            ZStack{
                                Color.white.frame(width: 110, height: 110)
                                Image(systemName: "lock.square")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .foregroundColor(.gray)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                            }.frame(height:110).cornerRadius(20).shadow(radius: 5)
                            ZStack{
                                Color.white.frame(width: 110, height: 110)
                                Image(systemName: "lock.square")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .foregroundColor(.gray)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                            }.frame(height:110).cornerRadius(20).shadow(radius: 5)
                        }.padding()
                        
                        HStack{
                            ZStack{
                                Color.white.frame(width: 110, height: 110)
                                Image(systemName: "lock.square")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                
                                    .foregroundColor(.gray)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                            }.frame(height:110).cornerRadius(20).shadow(radius: 5)
                            ZStack{
                                Color.white.frame(width: 110, height: 110)
                                Image(systemName: "lock.square")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .foregroundColor(.gray)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                            }.frame(height:110).cornerRadius(20).shadow(radius: 5)
                            ZStack{
                                Color.white.frame(width: 110, height: 110)
                                Image(systemName: "lock.square")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .foregroundColor(.gray)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                            }.frame(height:110).cornerRadius(20).shadow(radius: 5)
                        }.padding()
                        
                        HStack{
                            ZStack{
                                Color.white.frame(width: 110, height: 110)
                                Image(systemName: "lock.square")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .foregroundColor(.gray)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                            }.frame(height:110).cornerRadius(20).shadow(radius: 5)
                            ZStack{
                                Color.white.frame(width: 110, height: 110)
                                Image(systemName: "lock.square")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 110, height: 110)
                                    .foregroundColor(.gray)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                            }.frame(height:110).cornerRadius(20).shadow(radius: 5)
                            ZStack{
                                Color.white.frame(width: 110, height: 110)
                                Image(systemName: "lock.square")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .foregroundColor(.gray)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                            }.frame(height:110).cornerRadius(20).shadow(radius: 5)
                        }.padding()
                    }
                    
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .presentationCornerRadius(30)
                .presentationBackground(Color(hex: 0xFBF7EF))
                .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    ProfileView(currentExp: .constant(50), currentLevel: .constant(40), completedTask: .constant(10))
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

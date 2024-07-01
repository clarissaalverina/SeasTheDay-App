//
//  TaskRowView.swift
//  TodolistTest
//
//  Created by Vincent Senjaya on 19/06/24.
//
import SwiftUI
import SwiftData
import CoreHaptics
import AVFoundation

struct TaskRowView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var task: Task
    
    @Binding var currentExp : Int
    @Binding var currentLevel : Int
    @Binding var completedTask : Int
    
    @Binding var maxTaps: Int
    @Binding var progress: Double
    
    @Binding var moveToTop: Bool
    @Binding var isFloating: Bool
    @Binding var returnToInitial: Bool
    @Binding var backgroundOffset: CGFloat
    @Binding var componentFloating: Bool
    @Binding var showModal : Bool
    @State private var engine: CHHapticEngine?
    @State private var player: AVAudioPlayer?
    @State private var player2: AVAudioPlayer?
    
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
        
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
           HStack {
               Button(action: {
                   task.isCompleted.toggle()
                   if task.isCompleted {
                       addProgress()
                       moveBoat()
                       playSound()
                       complexSuccess()
                       if completedTask % 7 == 0 {
                          showModal = true
                           playSound2()
                      }
                   }
               }) {
                   Image(systemName: task.isCompleted ? "checkmark.square" : "square")
               }
               .disabled(task.isCompleted)
               .buttonStyle(PlainButtonStyle()) // This can help avoid default button styles interfering
               Divider()
               NavigationLink(destination: EditTaskView(task: task)) {
                   Text(task.title)
                       .foregroundColor(task.isCompleted ? .secondary : .primary)
                       .strikethrough(task.isCompleted, color: .secondary)
               }
//               Spacer()
//               Divider()
//               Text(checkPriority(task: task))
//                   .foregroundColor(task.isCompleted ? .secondary : .primary)
               
           }
           .preferredColorScheme(.light)
           .contentShape(Rectangle()) // Ensures the entire HStack is tappable for navigation
       }
    
    var filledReminderLabel: some View {
        Circle()
            .stroke(.primary, lineWidth: 2)
            .overlay(alignment: .center) {
                GeometryReader { geo in
                    VStack {
                        Circle()
                            .fill(.primary)
                            .frame(width: geo.size.width*0.7, height: geo.size.height*0.7, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
    }
    
    
    func addProgress(){
        completedTask += 1
        currentExp += 10
        if currentExp >= 100 {
            currentExp = 0
            currentLevel += 1
        }
        else if progress < Double(maxTaps) {
            progress += 1
            }
    }
    
    func moveBoat(){
        withAnimation(.easeInOut(duration: 2)) {
            moveToTop = true
            returnToInitial = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 2)) {
                moveToTop = false
                returnToInitial = true
                backgroundOffset += 200
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                isFloating.toggle()
                componentFloating.toggle()
            }
        }
    }
    
    func checkPriority(task: Task) -> String{
        if task.priority == 1{
            return "meh"
        } else if task.priority == 2{
            return "maybe"
        } else if task.priority == 3{
            return "must"
        } else {
            return "dunno"
        }
    }
    var emptyReminderLabel: some View {
        Circle()
            .stroke(.secondary)
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "sea sound", withExtension: "mp3")
        
        guard url != nil else {
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            player!.play()
        } catch {
            print("error")
        }
    }
    
    func playSound2() {
        let url = Bundle.main.url(forResource: "treasure sound", withExtension: "mp3")
        
        guard url != nil else {
            return
        }
        do {
            player2 = try AVAudioPlayer(contentsOf: url!)
            player2!.play()
        } catch {
            print("error")
        }
    }
}

//@ObservedObject var user: Userz
//class User: ObservableObject {
//    @Published var xp: Int = 0
//    
//    func addXP(_ amount: Int) {
//        xp += amount
//    }
//}

//#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: Reminder.self, configurations: config)
//        let example = Reminder(name: "Reminder Example", isCompleted: false)
//        
//        return ReminderRowView(reminder: example)
//            .modelContainer(container)
//    } catch {
//        fatalError("Failed to create model container")
//    }
//}



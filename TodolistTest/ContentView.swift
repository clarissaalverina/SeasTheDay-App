//
//  ContentView.swift
//  TodolistTest
//
//  Created by Clarissa Alverina on 17/06/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var newTaskTitle: String = ""
    @Query var tasks: [Task]
    @State private var path = [Task]()
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<Task> { task in
        task.isCompleted == false
    }) private var previewTasks : [Task]
    
    @Query(filter: #Predicate<Task> { task in
        task.isCompleted == true
    }) private var doneTasks : [Task]
    
    
    @State var selectedDay = Date()
    
    @Binding var currentExp : Int
    @Binding var currentLevel : Int
    @Binding var completedTask : Int
    @State private var tabSelection = 2
    
    @Binding var maxTaps: Int
    @Binding var progress: Double
    
    @Binding var moveToTop: Bool
    @Binding var isFloating: Bool
    @Binding var returnToInitial: Bool
    @Binding var backgroundOffset: CGFloat
    @Binding var componentFloating: Bool
    @Binding var showModal : Bool
    //testbro
    var body: some View {
            TabView(selection: $tabSelection){
                VStack{
                    
                    NavigationStack(path: $path) {
                        List {
                            ForEach(doneTasks) { task in
                                TaskRowView(task: task, currentExp: $currentExp, currentLevel: $currentLevel, completedTask: $completedTask, maxTaps: $maxTaps, progress: $progress, moveToTop: $moveToTop, isFloating: $isFloating, returnToInitial: $returnToInitial, backgroundOffset: $backgroundOffset, componentFloating: $componentFloating, showModal: $showModal)
                            }
                            .onDelete(perform: deleteTask)
                        }
                        .scrollContentBackground(.hidden)
                        .navigationTitle("Completed Task")
                        .navigationDestination(for: Task.self, destination: EditTaskView.init)
                    }
                                   
                }.tag(1)
                VStack{
                    NavigationStack(path: $path) {
//                        Button("Reset", systemImage: "minus", action: resetSwiftData)
                        List {
                            ForEach(previewTasks) { task in
                                TaskRowView(task: task, currentExp: $currentExp, currentLevel: $currentLevel, completedTask: $completedTask, maxTaps: $maxTaps, progress: $progress, moveToTop: $moveToTop, isFloating: $isFloating, returnToInitial: $returnToInitial, backgroundOffset: $backgroundOffset, componentFloating: $componentFloating, showModal: $showModal)
                            }
                            .onDelete(perform: deleteTask)
                        }
                        .scrollContentBackground(.hidden)
                        .navigationTitle("To-Do")
                        .toolbar {
                            Button("Add Task", systemImage: "plus", action: addTask)
                        }
                        .accentColor(Color(hex: 0x00463D))
                        .navigationDestination(for: Task.self, destination: EditTaskView.init)
                    }
                    .padding(.bottom, 40)
                    
                    //                Button("Reset", systemImage: "minus", action: resetSwiftData)
                    
                }.tag(2)
                VStack{
                    NavigationStack(path: $path) {
                        List {
                            CalendarTest(selectedDay: $selectedDay).padding()
                            ForEach(tasks) { task in
                                if task.date.string() == selectedDay.string() {
                                    TaskRowView(task: task, currentExp: $currentExp, currentLevel: $currentLevel, completedTask: $completedTask, maxTaps: $maxTaps, progress: $progress, moveToTop: $moveToTop, isFloating: $isFloating, returnToInitial: $returnToInitial, backgroundOffset: $backgroundOffset, componentFloating: $componentFloating, showModal: $showModal)
                                }
                            }
                            .onDelete(perform: deleteTask)
                        }
                        .scrollContentBackground(.hidden)
                        .navigationTitle("Schedule")
                    }
                }
                .tag(3)
                .padding(.bottom, 50)
            }
            .background(ignoresSafeAreaEdges: .bottom)
           
            .overlay(alignment: .bottom){
                TodoTabView(tabSelection: $tabSelection)
            }
    }
//    func addTask() {
//        let task = Task(title: "", isCompleted: false, details: "", date: "", priority: 2)
//        modelContext.insert(task)
////        path.append(task)
//    }
    
    func addTask(){
        let task = Task()
        modelContext.insert(task)
        path = [task]
    }
    
    func deleteTask(at offsets: IndexSet) {
        for offset in offsets {
            let task = tasks[offset]
            modelContext.delete(task)
        }
    }
    func resetSwiftData(){
        do {
            try modelContext.delete(model: Task.self)
        } catch {
            print("Failed to clear all data.")
        }
    }
}


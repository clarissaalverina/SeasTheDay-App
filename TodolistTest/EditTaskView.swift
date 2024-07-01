//
//  EditDestinationView.swift
//  iTour
//
//  Created by Vincent Senjaya on 19/06/24.
//

import SwiftUI
import SwiftData


struct EditTaskView: View {
    @Bindable var task: Task
    var body: some View {
        VStack{
            Form{
                TextField("Title", text: $task.title)
                TextField("Details", text: $task.details, axis: .vertical)
                DatePicker("Date", selection: $task.date)
                Section("Category"){
                    Picker("Category", selection: $task.priority){
                        Text("health").tag(1)
                        Text("work").tag(2)
                        Text("home").tag(3)
                    }.pickerStyle(.segmented).background(Color.clear)
                }
            }
            .background(Color.white)
        }
        .navigationTitle("Edit Task")
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
    
}

//#Preview {
//    EditTaskView()
//}


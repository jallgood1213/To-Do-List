//
//  ContentView.swift
//  ToDoListApp
//
//  Created by Josh Allgood on 3/26/25.
//


           
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    @StateObject private var taskVM = TaskViewModel()
    @State private var newTaskTitle = ""
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            VStack {
                TextField("New Task", text: $newTaskTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden()
                Button(action: {
                    guard !newTaskTitle.isEmpty else { return }
                    taskVM.AddTask(title: newTaskTitle, dueDate: selectedDate)
                    newTaskTitle = ""
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.largeTitle)
                }
            }
            .padding()
            List {
                ForEach(taskVM.tasks) { task in
                    HStack {
                        Button(action: {
                            taskVM.toggleCompletion(for: task)
                        }) {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                        }
                        Text(task.title)
                            .strikethrough(task.isCompleted, color: .black)
                        Text(DateFormatter.localizedString(from: task.dueDate, dateStyle: .medium, timeStyle: .short))
                        
                        Spacer()
                    }
                }
                .onDelete(perform: taskVM.deleteTask)
            }
            .navigationTitle("To-Do List")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}


#Preview {
    ContentView()
}

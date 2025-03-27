//
//  TaskViewModel.swift
//  ToDoListApp
//
//  Created by Josh Allgood on 3/26/25.
//
import Foundation

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet {
            saveTasks()
        }
}
    private let key = "tasks"
    
    init() {
        loadTasks()
    }
    func AddTask(title: String, dueDate: Date) {
        let newTask = Task(title: title, dueDate: dueDate)
        tasks.append(newTask)
        print("Task added: \(title)")
    }
    func toggleCompletion(for task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            //objectWillChange.send()
        }
        }
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    func saveTasks() {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: key) {
            if let decodedTasks = try? JSONDecoder().decode([Task].self, from: data) {
                tasks = decodedTasks
            }
        }
    }
}
                           

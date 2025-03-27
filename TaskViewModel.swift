//
//  TaskViewModel.swift
//  ToDoListApp
//
//  Created by Josh Allgood on 3/26/25.
//
import Foundation
import UserNotifications

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet {
            saveTasks()
        }
}
    private let key = "tasks"
    
    
    
    init() {
        loadTasks()
        requestNotificationPermission()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notification permission granted.")
            } else if error != nil {
                print("Try to remember to check back later!")
            }
        }
    }
    
    func AddTask(title: String, dueDate: Date) {
        let newTask = Task(title: title, dueDate: dueDate)
        tasks.append(newTask)
        scheduleLocalNotification(for: newTask)
        print("Task added: \(title)")
    }
    
    func scheduleLocalNotification(for task: Task) {
        let content = UNMutableNotificationContent()
        content.title = "It's time to do \(task.title)!"
        content.body = "Don't forget to complete your task!"
        content.sound = UNNotificationSound.default
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: task.dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
        
    }
    
    func toggleCompletion(for task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            //objectWillChange.send()
        }
        }
    func deleteTask(at offsets: IndexSet) {
        for index in  offsets {
            let task = tasks[index]
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
        }
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

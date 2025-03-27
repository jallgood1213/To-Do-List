//
//  Task.swift
//  ToDoListApp
//
//  Created by Josh Allgood on 3/26/25.
//
import Foundation
// struct represents to-do item
// identifiable protocol helps SwiftUI identify each task
// Coadable allows storage in UserDefaults
struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var dueDate: Date 
        
}


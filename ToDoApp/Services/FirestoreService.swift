//
//  FirestoreService.swift
//  ToDoApp
//
//  Created by Cemilcan Gorur on 2025-04-19.
//

import Foundation
import FirebaseFirestore

class FirestoreService: ObservableObject {
    private let db = Firestore.firestore()
    
    func saveTask(userID: String, task: Task, completion: @escaping (Error?) -> Void) {
        let taskData: [String: Any] = [
            "userID": userID,
            "taskID": task.id.uuidString,
            "title": task.title,
            "notes": task.notes ?? "",
            "dueDate": task.dueDate as Any,
            "location": task.location ?? "",
            "category": task.category ?? "",
            "isDone": task.isDone
        ]
        
        db.collection("Tasks").document(task.id.uuidString).setData(taskData) { error in
            completion(error)
        }
    }
    
    func updateTask(task: Task, completion: @escaping (Error?) -> Void) {
        let taskData: [String: Any] = [
            "title": task.title,
            "notes": task.notes ?? "",
            "dueDate": task.dueDate as Any,
            "location": task.location ?? "",
            "category": task.category ?? "",
            "isDone": task.isDone
        ]
        
        db.collection("Tasks").document(task.id.uuidString).updateData(taskData) { error in
            completion(error)
        }
    }
    
    func deleteTask(taskID: String, completion: @escaping (Error?) -> Void) {
        db.collection("Tasks").document(taskID).delete { error in
            completion(error)
        }
    }
    
    func deleteAllTasks(userID: String, completion: @escaping (Error?) -> Void) {
        db.collection("Tasks")
            .whereField("userID", isEqualTo: userID)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(nil)
                    return
                }
                
                let batch = self.db.batch()
                for document in documents {
                    batch.deleteDocument(document.reference)
                }
                
                batch.commit { error in
                    completion(error)
                }
            }
    }
    
    func getTasks(userID: String, completion: @escaping ([Task]?, Error?) -> Void) {
        db.collection("Tasks")
            .whereField("userID", isEqualTo: userID)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                let tasks = snapshot?.documents.compactMap { document -> Task? in
                    let data = document.data()
                    let taskID = data["taskID"] as? String ?? document.documentID
                    let title = data["title"] as? String ?? ""
                    let notes = data["notes"] as? String
                    let dueDate = (data["dueDate"] as? Timestamp)?.dateValue()
                    let location = data["location"] as? String
                    let category = data["category"] as? String
                    let isDone = data["isDone"] as? Bool ?? false
                    
                    let task = Task(title: title, notes: notes, dueDate: dueDate, location: location, category: category, isDone: isDone)
                    task.id = UUID(uuidString: taskID) ?? UUID()
                    return task
                }
                
                completion(tasks, nil)
            }
    }
}

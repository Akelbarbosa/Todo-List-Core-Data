//
//  TaskMethod.swift
//  TodoList-coreData
//
//  Created by Akel Barbosa on 16/07/22.
//

import Foundation
import CoreData

final class TaskMethodCoreData {
    private let container: NSPersistentContainer!
    
    init (){
        container = NSPersistentContainer(name: "TodoList_coreData")
        setupDataBase()
    }
    
    private func setupDataBase(){
        container.loadPersistentStores{ (desc, error) in
            
            if let error = error {
                print("Error loading store \(desc) — \(error)")
                return
            }
            print("data base ready")
        }
    }
    
    func updateStateTask(task: Tasks, state: Bool) {
        let context = container.viewContext
        task.done = state
        
        do {
            try context.save()

        } catch {
            print("Error al actualizar")
        }
        
    }
    
    
}

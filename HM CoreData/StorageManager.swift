//
//  StorageManager.swift
//  HM CoreData
//
//  Created by Dinar on 05.04.2023.
//


import CoreData


class StorageManager {
    
    static let shared = StorageManager()
    
    //MARK: - Core Data
   private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context = NSManagedObjectContext()
    
    private init() {
        context = persistentContainer.viewContext
    }
    
}
// MARK: - Create Task
extension StorageManager {
    func createTask(_ name: String, completion: (Task)-> Void) {
        let task = Task(context: context)
        task.name = name
        completion(task)
        saveTask()
    }
}


//MARK: - FetchData
extension StorageManager {
    func fetchData(completion: (Result<[Task], Error>)->Void) {
        let fetch = Task.fetchRequest
        
        do {
            let tasks = try context.fetch(fetch())
            completion(.success(tasks))
        } catch  let error {
            completion(.failure(error))
        }
    }
    
    
}

//MARK: - Function Task
extension StorageManager {
    
    func saveTask() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as? NSError
                print(nserror)
            }
        }
    }
    
    
    func deleteTask(_ task: Task) {
        context.delete(task)
        saveTask()
    }
    
    func update(_ task: Task, _ newName: String) {
        context.name = newName
        saveTask()
    }
    
}

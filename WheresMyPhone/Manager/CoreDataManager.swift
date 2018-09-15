//
//  CoreDataStack.swift
//  WheresMyPhone
//
//  Created by Marko Trajcevic on 9/11/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LocationModel")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private static let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
    
    static var context = persistentContainer.viewContext
    
    class func saveContext () {
        let context = persistentContainer.viewContext

        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    
    class func fetch() -> [Any]? {
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        }catch let err as NSError {
            print(err.debugDescription)
            return nil
        }
    }
    
    class func delete() {
        LocationManager.shared.stop()
        let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do{
            try context.execute(delete)
        }
        catch (let error) {
            print("Error deleting context \(error)")
        }
        
    }
    
    
}


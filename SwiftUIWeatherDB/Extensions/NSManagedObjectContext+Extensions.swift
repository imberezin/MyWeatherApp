//
//  NSManagedObjectContext+Extensions.swift
//

import Foundation
import UIKit
import CoreData

extension NSManagedObjectContext {
    
    static var current: NSManagedObjectContext {
      //  print(DBPersistentManger.shared.persistentContainer.viewContext)
        return DBPersistentManger.shared.persistentContainer.viewContext
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        return appDelegate.persistentContainer.viewContext
    }
    
}

//
//  HackerNewsItem.swift
//  Hacker News
//
//  Created by Sven on 5/28/16.
//  Copyright © 2016 Mikael Dunhem. All rights reserved.
//

import Foundation
import CoreData


class HackerNewsItem: NSManagedObject {

    class func hackerNewsItemWithID(id: Int, inManagedObjectContext context: NSManagedObjectContext) -> HackerNewsItem? {
        let request = NSFetchRequest(entityName: "HackerNewsItem")
        request.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        if let item = (try? context.executeFetchRequest(request))?.first as? HackerNewsItem {
            return item
        } else if let item = NSEntityDescription.insertNewObjectForEntityForName("HackerNewsItem", inManagedObjectContext: context) as? HackerNewsItem {
            item.id = Int64(id)
            item.read = false
            return item
        }
        
        return nil
    }
    
    class func readStatusForHackerNewsItemWithID(id: Int, inManagedObjectContext context: NSManagedObjectContext) -> Bool {
        let request = NSFetchRequest(entityName: "HackerNewsItem")
        request.predicate = NSPredicate(format: "id == %@", "\(id)")
        
        if let item = (try? context.executeFetchRequest(request))?.first as? HackerNewsItem {
            return item.read
        }
        
        return false
    }
    
    class func setReadStatus(status: Bool, forHackerNewsItem id: Int, inManagedObjectContext context: NSManagedObjectContext) -> HackerNewsItem? {
        let request = NSFetchRequest(entityName: "HackerNewsItem")
        request.predicate = NSPredicate(format: "id == %@", "\(id)")
        
        if let item = (try? context.executeFetchRequest(request))?.first as? HackerNewsItem {
            item.read = status
            do {
                try context.save()
                return item
            } catch let error {
                print("Failed to save read status: \(error)")
            }
        }
        
        return nil
    }

}

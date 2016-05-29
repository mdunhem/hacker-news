//
//  HackerNewsItem+CoreDataProperties.swift
//  Hacker News
//
//  Created by Sven on 5/28/16.
//  Copyright © 2016 Mikael Dunhem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension HackerNewsItem {

    @NSManaged var id: Int64
    @NSManaged var read: Bool

}

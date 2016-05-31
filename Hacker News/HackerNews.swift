//
//  HackerNews.swift
//  Hacker News
//
//  Created by Sven on 5/9/16.
//  Copyright © 2016 Mikael Dunhem. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol HackerNewsDelegate {
    func hackerNewsDidReturnNewStories(hackerNews: HackerNews)
    func hackerNews(hackerNews: HackerNews, didChangeItemAtIndex index: Int, forChangeType type: HackerNewsStoryChangeType)
}

public enum HackerNewsStoryChangeType {
    case Insert
    case Update
}

public enum HackerNewsItemType {
    case TopStories
    case NewStories
    case Show
    case Ask
    case Jobs
}

class HackerNews {
    
    private let baseURL = "https://hacker-news.firebaseio.com/v0/"
    
    private var fetchedItemIds: [Int] = [] {
        didSet {
            for item in fetchedItemIds {
                getStory(item)
                managedObjectContext?.performBlock {
                    _ = HackerNewsItem.hackerNewsItemWithID(item, inManagedObjectContext: self.managedObjectContext!)
                }
            }
            do {
                try managedObjectContext?.save()
            } catch let error {
                // TODO: Handle this error better
                print("Core Data error: \(error)")
            }

            delegate?.hackerNewsDidReturnNewStories(self)
        }
    }
    
    private var items: [HNItem] = []
    
    private func getStory(id: Int) {
        let fireStory = Firebase(url: baseURL + "item/\(id)")
        
        fireStory.observeEventType(.Value, withBlock: { snapshot in
            let item = HNItem(snapshot: snapshot)
            
            if let index = self.items.indexOf({ $0.id == item.id }) {
                self.items[index] = item
                self.delegate?.hackerNews(self, didChangeItemAtIndex: index, forChangeType: .Update)
            } else {
                self.items.append(item)
                self.delegate?.hackerNews(self, didChangeItemAtIndex: self.items.endIndex - 1, forChangeType: .Insert)
            }
            
        })
    }
    
    // MARK: Public API
    
    var delegate: HackerNewsDelegate?
    
    var managedObjectContext: NSManagedObjectContext?
    
    var numberOfItems: Int {
        return items.count
    }
    
    func item(at index: Int) -> HNItem? {
        if items.count > 0 {
            return items[index]
        }
        return nil
    }
    
    func load(type: HackerNewsItemType) {
        var url = baseURL
        
        switch type {
        case .TopStories:
            url += "topstories"
        case .NewStories:
            url += "newstories"
        case .Show:
            url += "showstories"
        case .Ask:
            url += "askstories"
        case .Jobs:
            url += "jobstories"
        }
        
        let itemsRef = Firebase(url: url)
        itemsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.fetchedItemIds = snapshot.value as! [Int]
        })
    }
    
    func loadKids(item: HNItem?) {
        if let kids = item?.kids {
            fetchedItemIds = kids
        }
    }
    
    
}
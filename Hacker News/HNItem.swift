//
//  HNItem.swift
//  Hacker News
//
//  Created by Sven on 5/9/16.
//  Copyright © 2016 Mikael Dunhem. All rights reserved.
//

import Foundation
import Firebase

struct HNItem {
    let id: Int
    let title: String?
    let url: NSURL?
//    let deleted: Bool?
    let type: Type?
    let by: String?
//    let time: NSDate?
    let text: String?
//    let dead: Bool?
    let descendants: Int?
    let kids: [Int]?
    let points: Int?
    
    
    enum Type : String {
        case Story = "story"
        case Job = "job"
        case Comment = "comment"
        case Poll = "poll"
        case PollOpt = "pollopt"
    }
    
    init(snapshot: FDataSnapshot) {
        id = (snapshot.value as? [String : AnyObject])?["id"] as! Int
        title = (snapshot.value as? [String : AnyObject])?["title"] as? String
        by = (snapshot.value as? [String : AnyObject])?["by"] as? String
        text = (snapshot.value as? [String : AnyObject])?["text"] as? String
        descendants = (snapshot.value as? [String : AnyObject])?["descendants"] as? Int
        type = Type(rawValue: ((snapshot.value as? [String : AnyObject])?["type"] as! String))
        if let url = (snapshot.value as? [String : AnyObject])?["url"] as? String {
            self.url = NSURL(string: url)
        } else {
            url = nil
        }
        
        kids = (snapshot.value as? [String : AnyObject])?["kids"] as? [Int]
        
        points = (snapshot.value as? [String : AnyObject])?["score"] as? Int
    }
}

//
//  HackerNewsItemCell.swift
//  Hacker News
//
//  Created by Sven on 5/13/16.
//  Copyright © 2016 Mikael Dunhem. All rights reserved.
//

import UIKit

class HackerNewsItemCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var urlLabel: UILabel!
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet var commentsButton: CommentsButton!
    
    var hackerNewsItem: HNItem? {
        didSet {
            configureView()
        }
    }
    
    var viewed: Bool = false {
        didSet {
            if viewed {
                titleLabel.textColor = UIColor.lightGrayColor()
                userLabel.textColor = UIColor.lightGrayColor()
                urlLabel.textColor = UIColor.lightGrayColor()
                pointsLabel.textColor = UIColor.lightGrayColor()
            } else {
                titleLabel.textColor = UIColor.darkTextColor()
                userLabel.textColor = UIColor.darkTextColor()
                urlLabel.textColor = UIColor.darkTextColor()
                pointsLabel.textColor = UIColor.darkTextColor()
            }
        }
    }
    
    private func configureView() {
        if let hackerNewsItem = hackerNewsItem {
            titleLabel.text = hackerNewsItem.title
            userLabel.text = hackerNewsItem.by
            if let url = hackerNewsItem.url {
                urlLabel.text = url.host
            }
            if let points = hackerNewsItem.points {
                pointsLabel.text = "\(points) points"
            }
            
        }
    }

}

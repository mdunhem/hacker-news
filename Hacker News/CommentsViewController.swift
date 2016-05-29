//
//  CommentsViewController.swift
//  Hacker News
//
//  Created by Sven on 5/15/16.
//  Copyright © 2016 Mikael Dunhem. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet var itemTextLabel: UILabel!
    @IBOutlet var userLabel: UILabel!
    
    var item: HNItem? {
        didSet {
            configureView()
        }
    }
    
    private var hackerNews = HackerNews()
    
    private var commentIDs: [Int]?
    
    private func configureView() {
        if let item = item {
            title = "\(item.descendants ?? 0) comments"
            commentIDs = item.kids
            if let itemTitle = item.title {
                itemTextLabel?.text = itemTitle
            }
            if let itemUser = item.by {
                userLabel?.text = itemUser
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hackerNews.delegate = self
        hackerNews.loadKids(item)
        
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CommentsViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 400
    }
}

extension CommentsViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return hackerNews.numberOfItems
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hackerNews.numberOfItems > 0 {
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let comment = hackerNews.item(at: section)
        if let username = comment?.by {
            return "\(username)"
        }
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentsTableViewCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: CommentsTableViewCell, atIndexPath indexPath: NSIndexPath) {
        let comment = hackerNews.item(at: indexPath.section)
        if let commentText = comment?.text {
//            cell.commentTextLabel.text = commentText
            cell.commentTextLabel.setHtml(commentText, forEncoding: NSUTF8StringEncoding)
        }
        
    }
}

extension CommentsViewController : HackerNewsDelegate {
    func hackerNewsDidReturnNewStories(hackerNews: HackerNews) {
        
    }
    
    func hackerNews(hackerNews: HackerNews, didChangeItemAtIndex index: Int, forChangeType type: HackerNewsStoryChangeType) {
        tableView.reloadData()
    }
}


extension UILabel {
    func setHtml(html: String, forEncoding encoding: NSStringEncoding) {
        let data = html.dataUsingEncoding(encoding)
        let options = [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType]
        do {
            let attributedString = try NSMutableAttributedString(data: data!, options: options, documentAttributes: nil)
            self.attributedText = attributedString
        } catch {
            return
        }
    }
}
//
//  NewsViewController.swift
//  Hacker News
//
//  Created by Sven on 5/8/16.
//  Copyright © 2016 Mikael Dunhem. All rights reserved.
//

import UIKit
import SafariServices

class NewsViewController: UIViewController, SequeHandlerType {
    
    let newsClient = HackerNews()
    let refreshControl = UIRefreshControl()
    
    enum SequeIdentifier: String {
        case ShowComments = "ShowComments"
    }

    @IBOutlet var tableView: UITableView!
    
    var clearsSelectionOnViewWillAppear = true {
        didSet {
            if clearsSelectionOnViewWillAppear {
                if let indexPath = tableView.indexPathForSelectedRow {
                    tableView.deselectRowAtIndexPath(indexPath, animated: false)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier, segueIdentifier = SequeIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier \(segue.identifier)")
        }
        
        switch segueIdentifier {
        case .ShowComments:
            if let button = sender as? CommentsButton {
                if let indexPath = button.indexPath {
                    let controller = (segue.destinationViewController as! UINavigationController).topViewController as! CommentsViewController
                    controller.item = newsClient.item(at: indexPath.row)
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                    controller.navigationItem.leftItemsSupplementBackButton = true
                    tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
//        navigationController?.navigationBar.backgroundColor = Style.NavigationBar.backgroundColor
        
        title = "Hacker News"
        newsClient.delegate = self
        newsClient.load(.TopStories)
        refreshControl.addTarget(self, action: #selector(refreshData), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = Style.TableView.backgroundColor
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    func refreshData() {
        newsClient.load(.TopStories)
    }
    
}

extension NewsViewController : HackerNewsDelegate {
    func hackerNewsDidReturnNewStories(hackerNews: HackerNews) {
        tableView.reloadData()
        if refreshControl.refreshing {
            refreshControl.endRefreshing()
        }
    }
    
    func hackerNews(hackerNews: HackerNews, didChangeItemAtIndex index: Int, forChangeType type: HackerNewsStoryChangeType) {
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        case .Update:
            print("Update indexPath.row: \(indexPath.row)")
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? HackerNewsItemCell {
                configure(cell, forIndexPath: indexPath)
            }
        }
    }
}

extension NewsViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let item = newsClient.item(at: indexPath.row)
        if let url = item?.url {
            let safariViewController = SFSafariViewController(URL: url)
            safariViewController.delegate = self
            navigationController?.presentViewController(safariViewController, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
}

extension NewsViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsClient.numberOfItems
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HackerNewsItemCell", forIndexPath: indexPath) as! HackerNewsItemCell
        configure(cell, forIndexPath: indexPath)
        return cell
    }
    
    func configure(cell: HackerNewsItemCell, forIndexPath indexPath: NSIndexPath) {
        let item = newsClient.item(at: indexPath.row)
        
        cell.titleLabel.text = item?.title!
        cell.userLabel.text = item?.by!
        cell.commentsButton.indexPath = indexPath
        
        if let url = item?.url {
            cell.urlLabel.text = url.host
        }
        
        if let points = item?.points {
            cell.pointsLabel.text = "\(points) points"
        }
        
        cell.backgroundColor = UIColor.clearColor()
        
//        cell.textLabel!.text = item.title!
//        if let descendants = item.descendants {
//            cell.detailTextLabel?.text = "\(descendants)"
//        }
    }
}

extension NewsViewController : SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
//        navigationController?.popViewControllerAnimated(true)
//        navigationController?.navigationBarHidden = false
    }
}


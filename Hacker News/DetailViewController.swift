//
//  DetailViewController.swift
//  Hacker News
//
//  Created by Sven on 5/8/16.
//  Copyright © 2016 Mikael Dunhem. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    var detailItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    var item: HNItem? {
        didSet {
            self.configureView()
        }
    }

    func configureView() {
        if let item = item {
            if let label = detailDescriptionLabel {
                if let text = item.text {
                    label.text = text
                } else if let url = item.url {
                    label.text = url.absoluteString
                } else {
                    label.text = item.title!
                }
            }
            if let descendants = item.descendants {
                title = "\(descendants) comments"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


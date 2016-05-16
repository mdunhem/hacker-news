//
//  SegueHandlerType.swift
//  Hacker News
//
//  Created by Sven on 5/8/16.
//  Copyright © 2016 Mikael Dunhem. All rights reserved.
//

import UIKit

protocol SequeHandlerType {
    associatedtype SequeIdentifier: RawRepresentable
}

extension SequeHandlerType where Self: UIViewController, SequeIdentifier.RawValue == String {
    func performSequeWithIdentifier(segueIdentifier: SequeIdentifier, sender: AnyObject?) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
    }
}

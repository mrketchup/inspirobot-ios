//
//  AppDelegate.swift
//  InspiroBot
//
//  Created by Matt Jones on 7/9/17.
//  Copyright © 2017 Matt Jones. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.tintColor = UIColor(red: 0.41, green: 0.71, blue: 0.41, alpha: 1)
        return true
    }

}


//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Elena Kulakova on 2019-01-27.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var memes = [Meme]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}


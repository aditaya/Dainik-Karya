//
//  AppDelegate.swift
//  Dainik-Karya
//
//  Created by Vineet Mahali on 14/07/20.
//  Copyright © 2020 Aditaya Rana. All rights reserved.
//

import UIKit

import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
 
        do {
            
            _ = try Realm()
        }
        catch {
            print("Error initialising new Realm \(error)")
        }
        
        
        return true
    }

    

}



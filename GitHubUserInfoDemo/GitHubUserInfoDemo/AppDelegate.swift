//
//  AppDelegate.swift
//  GitHubUserInfoDemo
//
//  Created by Yasin on 11/19/19.
//  Copyright © 2019 Yasin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey  : Any] = [:]) -> Bool {
        print(url)
        print(url.scheme)
        if url.scheme == "test-deeplinking" {
            let urlCom = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
            for item in urlCom?.queryItems ?? [] {
                if item.name == "code" {
                    getToken(code: item.value)
                }
            }
        }
        return true
    }
    
    func getToken(code: String?) {
        let urlStr = "https://github.com/login/oauth/access_token"
        var headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept": "application/json"
        ]
        Alamofire.request(urlStr, method: .post, parameters: ["client_id":"dd3378e2a461c81d6755",
                                                              "client_secret":"60ae51dda547de417ba16d1643d5e9efec739749",
                                                              "code":code!], encoding: URLEncoding.default, headers: headers)
            .responseJSON {[weak self] (response) in
                switch response.result {
                case .success(let json):
                    let data = JSON.init(json)
                    if let token = data["access_token"].string {
                        print(token)
                        let userDefaults = UserDefaults.standard
                        userDefaults.setValue(token, forKey: "token")
                        userDefaults.synchronize()
                    }
                    break
                case .failure(let error):
                    print("error:\(error)")
                    break
                }
        }
    }
    
    
}


//
//  AppDelegate.swift
//  resupply the taste
//
//  Created by Karl Cridland on 30/01/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var token: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        registerForPushNotifications()
        // fields filled in during use.
        Auth.auth().signIn(withEmail: "", password: "") { user, _ in
            if let _ = user{
                print("signed in")
            }
        }
        return true
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            [weak self] granted, error in
            print(self.hashValue)
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.connectToFcm()
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration failed!")
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        self.connectToFcm()
    }
    
    func connectToFcm() {
        InstanceID.instanceID().instanceID { (result, _) in
            if let result = result{
                Firebase.shared.add_token(result.token)
            }
        }
    }
    
    // This function will be called right after user tap on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let application = UIApplication.shared
        
      // tell the app that we have finished processing the user’s action / response
        
    }


}


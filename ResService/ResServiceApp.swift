//
//  ResServiceApp.swift
//  ResService
//
//  Created by Mateusz Tofil on 11/10/2022.
//

import SwiftUI
import Firebase
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication,
           didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            
        FirebaseApp.configure()
            
//        var ref = Database.database(url: "https://resservice-f26c6-default-rtdb.europe-west1.firebasedatabase.app/") //.reference().child("value").setValue("100")
//
//
//        var ref: DatabaseReference!
//
//        ref = Database.database(https://resservice-f26c6-default-rtdb.europe-west1.firebasedatabase.app/).reference()
        return true
    }
}

@main
struct ResServiceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

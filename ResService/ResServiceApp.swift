//
//  ResServiceApp.swift
//  ResService
//
//  Created by Mateusz Tofil on 11/10/2022.
//

import SwiftUI
import Firebase
import FirebaseCore

@main
struct ResServiceApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SignInView()
        }
    }
}

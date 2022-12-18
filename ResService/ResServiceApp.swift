//
//  ResServiceApp.swift
//  ResService
//
//  Created by Mateusz Tofil on 11/10/2022.
//

import SwiftUI
import Firebase
import FirebaseCore
import UIKit

@main
struct ResServiceApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SignInView()
//            storyBoardView().ignoresSafeArea()
//            ARUIView()
        }
    }
}

struct storyBoardView : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "Home")
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

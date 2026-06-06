//
//  PriceMadisonFinalProjectApp.swift
//  PriceMadisonFinalProject
//
//  Created by Madison Price on 12/3/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication,
                 open url: URL,
                 options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}



@main
struct PriceMadisonFinalProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension View {
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }

        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        

        return root
    }
}

let orange = Color(
    red: 255.0 / 255.0,
    green: 203.0 / 255.0,
    blue: 105.0 / 255.0
)

let yellow = Color(
    red: 255.0 / 255.0,
    green: 250.0 / 255.0,
    blue: 133.0 / 255.0
)

let pink = Color(
    red: 230.0 / 255.0,
    green: 92.0 / 255.0,
    blue: 111.0 / 255.0
)

let salmon = Color(
    red: 249.0 / 255.0,
    green: 141.0 / 255.0,
    blue: 119.0 / 255.0
)

let gold = Color(
    red: 255.0 / 255.0,
    green: 226.0 / 255.0,
    blue: 105.0 / 255.0
)

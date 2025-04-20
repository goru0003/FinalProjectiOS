//
//  ContentView.swift
//  ToDoApp
//
//  Created by Cemilcan Gorur on 2025-04-19.
//

import SwiftUI

struct BottomTabView: View {
    @State private var isLoggedIn = false
    @State private var currentUser: User?
    
    var body: some View {
        Group {
            if isLoggedIn, let user = currentUser {
                TabView {
                    TaskListView(user: user)
                        .tabItem {
                            Label("Tasks", systemImage: "checklist")
                        }
                    
                    ProfileView(user: user, isLoggedIn: $isLoggedIn, currentUser: $currentUser)
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                }
            } else {
                LoginView(isLoggedIn: $isLoggedIn, currentUser: $currentUser)
            }
        }
    }
}

#Preview {
    BottomTabView()
}

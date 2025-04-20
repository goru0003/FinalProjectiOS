//
//  AuthService.swift
//  ToDoApp
//
//  Created by Cemilcan Gorur on 2025-04-19.
//

import Foundation
import FirebaseAuth

class AuthService: ObservableObject {
    
    
    func signIn(email: String, password: String, completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let user = result?.user {
                completion(.success(user))
            }
        }
    }
    
    func createAccount(email: String, name: String, password: String, completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let user = result?.user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(user))
                }
            }
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
}

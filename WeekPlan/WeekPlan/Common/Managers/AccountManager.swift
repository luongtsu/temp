//
//  AccountManager.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 9/4/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import Foundation
import Firebase

class AccountManager {
    
    static let shared = AccountManager()
    var user: User!
    
    init() {
    }
    
    // Sign-in anonymous if needed, then start loading data
    
    func signInAnonymousIfNeed() {

        if let currentUser = Auth.auth().currentUser {
            user = currentUser
            print(user.uid)
            print(user.providerID)
            TargetManager.shared.startLoadingData()
        } else {
            // Check net work connection
            if Util.isNetworkReachable() {
                Auth.auth().signInAnonymously() { [weak self] (user, error) in
                    guard let `self` = self, let `user` = user else { return }
                    self.user = user
                    print(user.uid)
                    print(user.providerID)
                    TargetManager.shared.startLoadingData()
                }
            } else {
                Util.showCustomAlert(title: nil, message: "Please check your network connection", cancelTitle: "", parent: nil) { [weak self] _ in
                    guard let `self` = self else { return }
                    self.signInAnonymousIfNeed()
                }
            }
        }
    }
}

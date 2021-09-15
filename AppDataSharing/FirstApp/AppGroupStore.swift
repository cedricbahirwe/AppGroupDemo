//
//  AppGroupStore.swift
//  FirstApp
//
//  Created by Cédric Bahirwe on 15/09/2021.
//

import Foundation

/**

 This class enforces the fact that App Group applications get and set data at the same spot.
 It uses UserDefaults to store DeviceToken.
 And with the help of the `FileHelper` a shared `FileManager` container to store a custom text.

 **/
enum UserDefaultsKey: String {
    case userSessionData, deviceToken
}

public class AppGroupStore: ObservableObject {

    private let userDefaults: UserDefaults?
    private let fileHelper: FileHelper
    
    
    public struct UserModel: Codable {
        var username: String
        var email: String
    }

    public init(appGroupName: String) {
        self.userDefaults = UserDefaults(suiteName: appGroupName)
        self.fileHelper = FileHelper(appGroupName: appGroupName, fileName: "CustomText")
    }
    
    public private(set) var userSession: UserModel? {
        get {
            guard let data = userDefaults?.data(forKey: UserDefaultsKey.userSessionData.rawValue) else { return nil }
            return try? JSONDecoder().decode(UserModel.self, from: data)
        } set {
            let data = try? JSONEncoder().encode(newValue)
            userDefaults?.set(data, forKey: UserDefaultsKey.userSessionData.rawValue)
            objectWillChange.send()
        }
    }

    public var deviceToken: String? {
        get {
            userDefaults?.string(forKey: UserDefaultsKey.deviceToken.rawValue)
        }
        set {
            userDefaults?.set(newValue, forKey: UserDefaultsKey.deviceToken.rawValue)
            objectWillChange.send()
        }
    }

    public var customText: String? {
        get {
            return fileHelper.contentOfFile()
        }
        set {
            fileHelper.write(message: newValue)
            objectWillChange.send()
        }
    }
    
    
    public func storeSessionLocally(for user: UserModel) {
        userSession = user
    }
    
    public func removeCurrentSession() {
        userSession = nil
    }
    
    public func refreshSession() {
        userSession = userSession
    }
}

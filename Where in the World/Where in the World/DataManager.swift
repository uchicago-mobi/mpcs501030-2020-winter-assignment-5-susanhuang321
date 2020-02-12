//
//  DataManager.swift
//  Where in the World
//
//  Created by Susan on 2/10/20.
//  Copyright © 2020 Susan. All rights reserved.
/* Sources
 https://stackoverflow.com/questions/24045570/how-do-i-get-a-plist-as-a-dictionary-in-swift
 https://stackoverflow.com/questions/30540123/displaying-an-array-of-dictionaries-from-a-plist-to-a-tableview-swift-arraydi
 */

import Foundation

public class DataManager {
  
    public static let sharedInstance = DataManager()
    let defaults = UserDefaults.standard
    
    

    fileprivate init() {}

    
    func saveToFavorites(_ currentAnnotation: String) {
        var arr = defaults.array(forKey: "favorites") as? [String] ?? [String]()
        arr.append(currentAnnotation)
        defaults.set(arr, forKey: "favorites")
    }
    
    func removeFromFavorites(_ currentAnnotation: String) {
        var arr = defaults.array(forKey: "favorites") as? [String] ?? [String]()
        var index = -1
        for item in arr {
            index += 1
            if currentAnnotation == item {
                break
            }
        }
        arr.remove(at: index)
        defaults.set(arr, forKey: "favorites")
    }
    
    func getFavorites() -> [String] {
        return defaults.array(forKey: "favorites") as? [String] ?? [String]()
    }
    


    
}

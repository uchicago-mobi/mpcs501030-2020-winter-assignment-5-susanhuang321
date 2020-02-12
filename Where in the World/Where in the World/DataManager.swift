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
  
  // MARK: - Singleton Stuff
    public static let sharedInstance = DataManager()
    let defaults = UserDefaults.standard
    
    

  //This prevents others from using the default '()' initializer
    fileprivate init() {}

  // Your code (these are just example functions, implement what you need)
    /*func loadAnnotationFromPlist() {
        
    }*/
    
    
    
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

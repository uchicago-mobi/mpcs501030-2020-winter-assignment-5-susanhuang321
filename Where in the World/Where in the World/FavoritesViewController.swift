//
//  FavoritesViewController.swift
//  Where in the World
//
//  Created by Susan on 2/9/20.
//  Copyright © 2020 Susan. All rights reserved.
//

import UIKit

protocol PlacesFavoritesDelegate: class {
  func favoritePlace(name: String) -> Void
}

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet var tableView: UITableView!
    weak var delegate: PlacesFavoritesDelegate?
    var favorites: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        favorites = DataManager.sharedInstance.getFavorites()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoritesTableViewCell
        
        let favorite = favorites[indexPath.row]
        cell.title.text = favorite
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.favoritePlace(name: DataManager.sharedInstance.getFavorites()[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

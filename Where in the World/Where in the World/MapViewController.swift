//
//  ViewController.swift
//  Where in the World
//
//  Created by Susan on 2/8/20.
//  Copyright © 2020 Susan. All rights reserved.
/* Sources
 https://iosdevcenters.blogspot.com/2017/11/what-is-protocol-how-to-pop-data-using.html
 https://stackoverflow.com/questions/30540123/displaying-an-array-of-dictionaries-from-a-plist-to-a-tableview-swift-arraydi
 https://www.hackingwithswift.com/example-code/location/how-to-add-annotations-to-mkmapview-using-mkpointannotation-and-mkpinannotationview
 */

import UIKit
import MapKit

struct Root: Codable{
    var places: [Places]?
}
struct Places: Codable {
    var name: String
    var description: String
    var lat: Double
    var long: Double
}

class MapViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var details: UIView!
    
    @IBOutlet var favorites: UIButton!
    
    @IBOutlet var starButton: UIButton!
    
    @IBOutlet var placeName: UILabel!
    
    @IBOutlet var placeDescription: UILabel!
    var places: [Places] = []
    
    var currentSelectedAnnotation: String = ""
   
    var starFilled = false
    
    var favArray: [String] = []
    
    var annotationSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        starFilled = false
        starButton.setImage((UIImage(named: "star")), for: .normal)
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        
        let coordinates = CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let initialLocation = MKCoordinateRegion(center: coordinates, span: span)
        mapView.setRegion(initialLocation, animated: true)
        mapView.delegate = self
        
        self.view.bringSubviewToFront(favorites)
        self.view.bringSubviewToFront(details)
        placeName.text = "Select a Location"
        placeDescription.text = "To add to your favorite locations"
        
        annotationSelected = false
        
        addAnnotations()
        
    }
    
    func addAnnotations(){
        var data: Root?
        guard let path = Bundle.main.path(forResource: "Data", ofType: "plist") else { return }
        guard let contents = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return }
        let decoder = PropertyListDecoder()
        data = try? decoder.decode(Root.self, from: contents)
        if let places = data?.places{
            self.places = places
            for place in places{
                let annotation = Place(lat: place.lat, long: place.long)
                annotation.name = place.name
                annotation.longDescription = place.description
                annotation.title = place.name
                annotation.subtitle = place.description
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    

    @IBAction func star(_ sender: Any) {
        if(annotationSelected){
            if starFilled{
                starButton.setImage(UIImage(named: "star"), for: .normal)
                starFilled = false
            }else{
                starButton.setImage(UIImage(named: "star.fill"), for: .normal)
                starFilled = true
            }
            var index = -1
            for place in places {
                index+=1
                if currentSelectedAnnotation == place.name{
                    break
                }
                
            }
            
            if(starFilled){
                favArray = DataManager.sharedInstance.getFavorites()
                DataManager.sharedInstance.saveToFavorites(currentSelectedAnnotation)
         
            }else{
                favArray = DataManager.sharedInstance.getFavorites()
                DataManager.sharedInstance.removeFromFavorites(currentSelectedAnnotation)
                favArray = DataManager.sharedInstance.getFavorites()
                /*favArray = DataManager.sharedInstance.defaults.object(forKey:"favorites") as? [String] ?? [String]()
                var index = -1
                for favorite in favArray {
                    index+=1
                    if currentSelectedAnnotation == favorite {
                        break
                    }
                    
                }
                favArray.remove(at: index)
                DataManager.sharedInstance.defaults.set(currentSelectedAnnotation, forKey: "favorites")*/
            }
        }
    }
    
    private func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> PlaceMarkerView? {//MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView as? PlaceMarkerView

    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        var isFav = false
        annotationSelected = true
        placeName.text = view.annotation!.title!!
        placeDescription.text = (view.annotation?.subtitle)!
        currentSelectedAnnotation = view.annotation!.title!!
        favArray = DataManager.sharedInstance.getFavorites()
        var index = -1
        for favorite in favArray {
            index+=1
            if currentSelectedAnnotation == favorite {
                isFav = true
                break
            }
        }
        
        if(isFav){
            starFilled = true
            starButton.setImage(UIImage(named: "star.fill"), for: .normal)
        }else {
            starFilled = false
            starButton.setImage(UIImage(named: "star"), for: .normal)
        }
    }
}


extension MapViewController: PlacesFavoritesDelegate {
    func favoritePlace(name: String){
        //destination.delegate = self // IF DOESNT WORK, TRY IN FAVORITES VIEW CONTROLLER
        var data: Root?
        guard let path = Bundle.main.path(forResource: "Data", ofType: "plist") else { return }
        guard let contents = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return }
        let decoder = PropertyListDecoder()
        data = try? decoder.decode(Root.self, from: contents)
        if let places = data?.places{
            for place in places{
                if place.name == name {
                    let lat = place.lat
                    let long = place.long
                    let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
                    let favoriteLocation = MKCoordinateRegion(center: coordinates, span: span)
                    mapView.setRegion(favoriteLocation, animated: true)
                    mapView.region = favoriteLocation
                    break
                }
            }
        }
        
    }

}


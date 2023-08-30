//
//  ContentViewModel.swift
//  Map
//
//  Created by Suli Rashidzada on 8/12/23.
//

import MapKit

final class ContentViewModel : NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 40.7, longitude: -74),
        span: MKCoordinateSpan(
            latitudeDelta: 0.5,
            longitudeDelta: 0.5)
    )
    
    var locationManager: CLLocationManager?

    @Published var displayCords : [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    
    @Published var allLocations : [Location] = [Location]()
    
    var filterType = Filter.normal
    
    func checkLocationServices() { 
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self;
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.distanceFilter = kCLDistanceFilterNone
            locationManager?.startUpdatingLocation()
        }
        else {
            print("throw error saying location is off and it needs to be turned on")
        }
    }
    
    private func checkLocationAuth() {
        guard let locationManager = locationManager else {
            return
        }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            print("your location is restricted likely due to parental controls")
        case .denied:
            print("you denied location permissions to this app change location permissions for this app in settings")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(
                center: locationManager.location!.coordinate,
                span: region.span)
        @unknown default:
            break
        }
    }
    
    func setFilterType(type : Filter) {
        filterType = type
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        addLocation(cord: userLocation.coordinate)
        // update list of displayed cords 
        filterThroughEnum()
    }
    
    // Controls the display of locations based on enum cases, will filter all locations based on user input 
    func filterThroughEnum() {
        switch filterType {
            
        case .normal:
            defaulatDisplay()
        case .byTenSeconds:
            filterByTime(timeInterval: 10)
        case .byOneDay:
            filterByTime(timeInterval: 86400)
        }
    
    }
    
    // If location is already contained in all location list, update most recent time for that location
    // else add it to the end of the location list as a new location
    func addLocation(cord: CLLocationCoordinate2D) {
        var temp : CLLocationCoordinate2D
        for l in allLocations {
            temp = l.coordinate
            let sameCord = temp.latitude == cord.latitude && temp.longitude == cord.longitude
            if sameCord {
                // set the most recent date to the date user got to new location
                l.recentDate = Date()
                // return since we have found this location already
                return
            }
        }
        // if this location has never been found before add to the end of the list with the current date
        allLocations.append(Location(coordinate: cord, dateFound: Date()))
    }
    
    // Sets display list to filtered version of all locations based on bool function passed in 
    func filter(for f: (Location) -> Bool) {
        var arr : [CLLocationCoordinate2D] = []
        for location in allLocations {
            if f(location) {
                arr.append(location.coordinate)
            }
        }
        displayCords = arr;
        print("\(displayCords.count), \(allLocations.count)")
    }
    
    // Gets all coordinates traveled within certain timeframe
    func filterByTime(timeInterval: TimeInterval) {
        let f : (Location) -> Bool = { (location : Location) -> Bool in
            return -location.recentDate.timeIntervalSinceNow <= timeInterval;
        }
        filter(for: f)
    }
    
    // Display all locations the user has gone through since start
    func defaulatDisplay() {
        let f : (Location) -> Bool = { (location: Location) -> Bool in
            return true
        }
        filter(for: f)
    }
}

enum Filter {
    case normal, byTenSeconds, byOneDay
}

// Represents a location which stores coordinate of location, as well as date discovered and most revent visitied date
class Location {
    var coordinate : CLLocationCoordinate2D
    var dateFound : Date
    var recentDate : Date {
        didSet {
            print("Most recent date is now \(recentDate)")
        }
    }
    
    init(coordinate: CLLocationCoordinate2D, dateFound: Date) {
        self.coordinate = coordinate
        self.dateFound = dateFound
        self.recentDate = dateFound
    }
}



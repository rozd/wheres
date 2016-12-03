//
//  MapViewController.swift
//  Wheres
//
//  Created by Max Rozdobudko on 11/30/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import UIKit
import MapKit
import AlamofireImage

class MapViewController: UIViewController, MapViewModelDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate
{
    //-------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //-------------------------------------------------------------------------
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var usersTableView: UITableView!
    
    var viewModel:MapViewModel!
    
    //-------------------------------------------------------------------------
    //
    //  MARK: - Overridden methods
    //
    //-------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.viewModel.delegate = self
        self.viewModel.monitorUsers()
        self.viewModel.monitorLocations(within: self.mapView.region)
        
        self.usersTableView.delegate = self
        self.usersTableView.dataSource = self
        
        self.mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //-------------------------------------------------------------------------
    //
    //  Delegates
    //
    //-------------------------------------------------------------------------
    
    //-------------------------------------
    //  MARK: - MapViewModelDelegate
    //-------------------------------------
    
    func mapViewModelDidUserAdded(user: User)
    {
        let row = self.viewModel.users.count - 1
        let indexPath = IndexPath(row: row, section: 0)
        
        self.usersTableView.insertRows(at: [indexPath], with: .top)
    }
    
    func mapViewModelDidUserRemoved(user: User, atIndex index: Int)
    {
        let indexPath = IndexPath(row: index, section: 0)
        
        self.usersTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func mapViewModelDidUsersChange(users:[User])
    {
        self.usersTableView.reloadData()
    }
    
    func mapViewModelDidUserChanged(user: User, atIndex index: Int)
    {
        if let cell = self.usersTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FriendViewCell
        {
            if let friendLocation = user.location, let myLocation = self.mapView.userLocation.location
            {
                let distance = myLocation.distance(from: friendLocation)
                
                cell.distanceLabel.text = MKDistanceFormatter().string(fromDistance: distance)
            }
        }
    }
    
    func mapViewModelDidUserAnnotationAdded(annotation: UserAnnotation)
    {
        self.mapView.addAnnotation(annotation)
    }
    
    func mapViewModelDidUserAnnotationRemoved(annotation: UserAnnotation)
    {
        self.mapView.removeAnnotation(annotation)
    }
    
    //-------------------------------------
    //  MARK: UITableViewDataSource
    //-------------------------------------
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.viewModel.users.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let user = self.viewModel.users[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendViewCell") as! FriendViewCell
        cell.displayNameLabel.text = user.displayName
        
        if let avatarURL = user.smallAvatarURL
        {
            cell.avatarImageView.af_setImage(withURL: avatarURL)
        }
        
        if let friendLocation = user.location, let myLocation = self.mapView.userLocation.location
        {
            let distance = myLocation.distance(from: friendLocation)
            
            cell.distanceLabel.text = MKDistanceFormatter().string(fromDistance: distance)
        }
        
        return cell
    }
    
    //-------------------------------------
    //  MARK: UITableViewDataSource
    //-------------------------------------
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let user = self.viewModel.users[indexPath.row]
        
        if let location = user.location
        {
            self.mapView.setCenter(location.coordinate, animated: true)
        }
        
    }
    
    //-------------------------------------
    //  MARK: MKMapViewDelegate
    //-------------------------------------
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        self.viewModel.monitorLocations(within: self.mapView.region)
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation
        {
            return nil // use default view
        }
        else if let friendAnnotation = annotation as? UserAnnotation
        {
            let reuseIdentifier = "FriendAnnotationView"
            
            let friendAnnotationView =
                self.mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? FriendAnnotationView ??
                FriendAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            
            friendAnnotationView.avatarURL = friendAnnotation.user.extraSmallAvatarURL
            
            return friendAnnotationView
        }
        
        return nil
    }
    
    public func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
    {
        self.usersTableView.reloadData()
    }
}

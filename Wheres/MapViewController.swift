//
//  MapViewController.swift
//  Wheres
//
//  Created by Max Rozdobudko on 11/30/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MapViewModelDelegate, UITableViewDataSource, MKMapViewDelegate
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
        
        self.usersTableView.dataSource = self
        self.mapView.delegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //-------------------------------------------------------------------------
    //
    //  MARK: Delegates
    //
    //-------------------------------------------------------------------------
    
    //-------------------------------------
    //  MapViewModelDelegate
    //-------------------------------------
    
    func mapViewModelDidUserAdded(user: User)
    {
        let row = self.viewModel.users.count - 1
        let indexPath = IndexPath(row: row, section: 0)
        
        self.usersTableView.insertRows(at: [indexPath], with: .top)
    }
    
    func mapViewModelDidUserRemoved(user: User, fromIndex index: Int)
    {
        let indexPath = IndexPath(row: index, section: 0)
        
        self.usersTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func mapViewModelDidUsersChange(users:[User])
    {
        self.usersTableView.reloadData()
    }
    
    //-------------------------------------
    //  UITableViewDataSource
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
        
        return cell
    }
    
    //-------------------------------------
    //  MKMapViewDelegate
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
        else if annotation is UserAnnotation
        {
            
        }
        
        return nil
    }
    
    func mapViewModelDidUserAnnotationAdded(annotation: UserAnnotation)
    {
        self.mapView.addAnnotation(annotation)
    }
    
    func mapViewModelDidUserAnnotationRemoved(annotation: UserAnnotation)
    {
        self.mapView.removeAnnotation(annotation)
    }
}

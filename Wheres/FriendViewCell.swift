//
//  FriendViewCell.swift
//  Wheres
//
//  Created by Max Rozdobudko on 12/1/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire

class FriendViewCell: UITableViewCell
{
    //--------------------------------------------------------------------------
    //
    //  MARK: Properties
    //
    //--------------------------------------------------------------------------
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var displayNameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    //--------------------------------------------------------------------------
    //
    //  MARK: Variables
    //
    //--------------------------------------------------------------------------
    
    private var currentFriend: User?
    
    //--------------------------------------------------------------------------
    //
    //  MARK: Properties
    //
    //--------------------------------------------------------------------------
    
    
    
    //--------------------------------------------------------------------------
    //
    //  MARK: Overridden methods
    //
    //--------------------------------------------------------------------------
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        let borderLayer = CALayer();
        borderLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.avatarImageView.bounds.width, height: self.avatarImageView.bounds.height)
        borderLayer.cornerRadius = CGFloat(self.avatarImageView.bounds.width / 2.0);
        borderLayer.borderWidth = 4.0;
        borderLayer.borderColor = UIColor.redCadmium.cgColor
        
        self.avatarImageView.layer.addSublayer(borderLayer);
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: Methods
    //
    //--------------------------------------------------------------------------
    
    func populateFields(with user: User, myLocation location: CLLocation?)
    {
        self.displayNameLabel.text = user.displayName
        
        if let avatarURL = user.smallAvatarURL
        {
            self.avatarImageView.af_setImage(withURL: avatarURL)
        }
        
        if let friendLocation = user.location, let myLocation = location
        {
            let distance = myLocation.distance(from: friendLocation)
            
            self.distanceLabel.text = MKDistanceFormatter().string(fromDistance: distance)
        }
        
        // cancel previous request
        
        
        // request address by location once per user 
        // TODO: add possibility to update after some delay
        // TODO: or better store address for
        
        guard self.currentFriend?.uid != user.uid else {
            self.currentFriend = user
            return
        }
        
        self.currentFriend = user
        
        if let friendLocation = self.currentFriend?.location
        {
//            Geocoder.sharedGeocoder
        }
    }
}

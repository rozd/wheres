//
//  FriendViewCell.swift
//  Wheres
//
//  Created by Max Rozdobudko on 12/1/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import UIKit

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
    //  MARK: Overridden methods
    //
    //--------------------------------------------------------------------------
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        let borderLayer = CALayer();
        borderLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.avatarImageView.bounds.width, height: self.avatarImageView.bounds.height)
        borderLayer.cornerRadius = CGFloat(self.avatarImageView.bounds.width / 2.0);
        borderLayer.borderWidth = 2.0;
        borderLayer.borderColor = UIColor.redCadmium.cgColor
        
        self.avatarImageView.layer.addSublayer(borderLayer);
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

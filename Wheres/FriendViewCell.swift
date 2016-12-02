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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

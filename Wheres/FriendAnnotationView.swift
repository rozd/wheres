//
//  FriendAnnotationView.swift
//  Wheres
//
//  Created by Max Rozdobudko on 12/3/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

import UIKit
import MapKit

class FriendAnnotationView: MKAnnotationView
{
    //--------------------------------------------------------------------------
    //
    //  MARK: - Lifecycle
    //
    //--------------------------------------------------------------------------
    
    override init(annotation: MKAnnotation!, reuseIdentifier: String!)
    {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.createSubviews();
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.createSubviews()
    }
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    //--------------------------------------------------------------------------
    //
    //  MARK: - Properties
    //
    //--------------------------------------------------------------------------
    
    private var imageView: UIImageView!
    
    var avatarURL: URL?
    {
        didSet
        {
            updateAvatarURL()
        }
    }
    
    
    //--------------------------------------------------------------------------
    //
    //  MARK: - Methods
    //
    //--------------------------------------------------------------------------
    
    private func createSubviews()
    {
        let size = WheresFriendAnnotationViewSize
        
        self.imageView = UIImageView()
        self.imageView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        self.addSubview(self.imageView)
        
        updateAvatarURL()
        
        self.layer.masksToBounds = true
        
        let borderLayer = CALayer();
        borderLayer.frame = CGRect(x: 0, y: 0, width: size, height: size);
        borderLayer.cornerRadius = CGFloat(size / 2);
        borderLayer.borderWidth = 2.0;
        borderLayer.borderColor = UIColor.redCadmium.cgColor;
        
        self.layer.addSublayer(borderLayer);
        
        self.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        self.layer.cornerRadius = CGFloat(size / 2)
    }
    
    private func updateAvatarURL()
    {
        if let url = self.avatarURL
        {
            self.imageView?.af_setImage(withURL: url)
        }
        else
        {
            self.imageView?.image = nil
        }
    }
}

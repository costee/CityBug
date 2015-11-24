//
//  RouteViewCell.swift
//  CityBug
//
//  Created by Nagy Konstantin on 2015. 08. 12..
//  Copyright (c) 2015. Nagy Konstantin. All rights reserved.
//

import UIKit

class RouteViewCell: UITableViewCell {
    
    var route: Route? {
        didSet {
            updateUI()
        }
    }


    @IBOutlet weak var routeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!

    func updateUI() {
        if let route = self.route {
            titleLabel.text = route.title
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .ShortStyle
            startLabel.text = route.formattedStart(true)
            
            if let image = SaveAssistant.sharedInstance.loadImage(route) {
                routeImageView.bounds = CGRect(x: 0, y: 0, width: 84, height: 84)
                routeImageView.image = image
                routeImageView.contentMode = UIViewContentMode.ScaleAspectFill
            }
            
            routeImageView.autoresizingMask = UIViewAutoresizing.None
            routeImageView.clipsToBounds = true
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

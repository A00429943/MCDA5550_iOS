//
//  DetailsViewController.swift
//  GetGoingClass
//
//  Created by Simon Achkar on 2/8/19.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var details: PlaceDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = details.name ?? ""
        phoneLabel.text = details.phone ?? ""
        websiteLabel.text = details.website ?? ""
        // Do any additional setup after loading the view.
    }
    
}

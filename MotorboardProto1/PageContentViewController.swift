//
//  PageContentViewController.swift
//  MotorboardProto1
//
//  Created by Pete Petrash on 11/28/14.
//  Copyright (c) 2014 Pete Petrash. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var pageIndex: Int = 0
    var titleText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


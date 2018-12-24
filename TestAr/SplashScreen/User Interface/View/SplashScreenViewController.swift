//
//  SplashScreenViewController.swift
//  TestAr
//
//  Created by Prajwal Kc on 12/24/18.
//Copyright © 2018 ekBana. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    // MARK: Properties
    
    var presenter: SplashScreenModuleInterface?
    
    // MARK: IBOutlets
    
    // MARK: VC's Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: IBActions
    
    // MARK: Other Functions
    
    private func setup() {
        // all setup should be done here
    }
}

// MARK: SplashScreenViewInterface
extension SplashScreenViewController: SplashScreenViewInterface {
    
}

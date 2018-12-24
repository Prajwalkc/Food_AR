//
//  SplashScreenPresenter.swift
//  TestAr
//
//  Created by Prajwal Kc on 12/24/18.
//Copyright © 2018 ekBana. All rights reserved.
//

import Foundation

class SplashScreenPresenter {
    
	// MARK: Properties
    
    weak var view: SplashScreenViewInterface?
    var interactor: SplashScreenInteractorInput?
    var wireframe: SplashScreenWireframeInput?

    // MARK: Converting entities
}

 // MARK: SplashScreen module interface

extension SplashScreenPresenter: SplashScreenModuleInterface {
    
}

// MARK: SplashScreen interactor output interface

extension SplashScreenPresenter: SplashScreenInteractorOutput {
    
}

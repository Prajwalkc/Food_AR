//
//  SplashScreenInteractor.swift
//  TestAr
//
//  Created by Prajwal Kc on 12/24/18.
//Copyright © 2018 ekBana. All rights reserved.
//

import Foundation

class SplashScreenInteractor {
    
	// MARK: Properties
    
    weak var output: SplashScreenInteractorOutput?
    private let service: SplashScreenServiceType
    
    // MARK: Initialization
    
    init(service: SplashScreenServiceType) {
        self.service = service
    }

    // MARK: Converting entities
}

// MARK: SplashScreen interactor input interface

extension SplashScreenInteractor: SplashScreenInteractorInput {
    
}

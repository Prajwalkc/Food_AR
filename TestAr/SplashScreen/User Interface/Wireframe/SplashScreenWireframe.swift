//
//  SplashScreenWireframe.swift
//  TestAr
//
//  Created by Prajwal Kc on 12/24/18.
//Copyright © 2018 ekBana. All rights reserved.
//

import UIKit

class SplashScreenWireframe {
     weak var view: UIViewController!
}

extension SplashScreenWireframe: SplashScreenWireframeInput {
    
    var storyboardName: String {return "SplashScreen"}
    
    func getMainView() -> UIViewController {
        let service = SplashScreenService()
        let interactor = SplashScreenInteractor(service: service)
        let presenter = SplashScreenPresenter()
        let viewController = viewControllerFromStoryboard(of: SplashScreenViewController.self)
        
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self
        presenter.view = viewController
        
        self.view = viewController
        return viewController
    }
}

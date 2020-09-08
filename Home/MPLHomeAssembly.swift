//
//  MPLHomeAssembly.swift
//  Marketplace
//
//  Created by Kirill Shalankin on 17/06/2019.
//  Copyright © 2019 Korablik. All rights reserved.
//

import Foundation

class MPLHomeAssembly: NSObject {
    class func createModule(viewController: MPLHomeViewController) {
        let presenter = MPLHomePresenter()
        let interactor = MPLHomeInteractor()
        let dataManager = MPLHomeDataManager()
        let router = MPLHomeRouter()
        
        viewController.output = presenter
        viewController.dataManager = dataManager
        dataManager.view = viewController
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.view = viewController
    }
}

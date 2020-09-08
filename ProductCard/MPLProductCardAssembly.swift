//
//  MPLProductCardAssembly.swift
//  Marketplace
//
//  Created by Kirill Shalankin on 24/09/2019.
//  Copyright © 2019 Korablik. All rights reserved.
//

import UIKit

class MPLProductCardAssembly: NSObject {
    class func createModule(viewController: MPLProductCardViewController) {
        let presenter = MPLProductCardPresenter()
        let interactor = MPLProductCardInteractor()
        let dataManager = MPLProductCardDataManager()
        let router = MPLProductCardRouter()
        
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

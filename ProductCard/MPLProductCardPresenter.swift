//
//  MPLProductCardPresenter.swift
//  Marketplace
//
//  Created by Kirill Shalankin on 24/09/2019.
//  Copyright © 2019 Korablik. All rights reserved.
//

import UIKit

class MPLProductCardPresenter: NSObject, MPLProductCardViewOutput, MPLProductCardInteractorOutput, MPLProductCardModuleConfigurator {

    // MARK: - Public vars & lets
    
    public var view: MPLProductCardViewInput?
    public var interactor: MPLProductCardInteractorInput?
    public var router: MPLProductCardRouterInput?
    
    
    // MARK: - Private vars & lets
    
    private var id: String = ""
    
    
    // MARK: - MPLProductCardModuleConfigurator
    
    func configureModule(id: String, name: String) {
        self.id = id
    }
    
    
    // MARK: - MPLProductCardViewOutput
    
    func viewDidLoad() {
        interactor?.downloadProduct(id: id)
    }
    
    
    // MARK: - MPLProductCardInteractorOutput
    
    func productDownloaded(product: APIResponse.Product) {
        view?.configure(product: product)
    }
}

//
//  MPLProductCardProtocol.swift
//  Marketplace
//
//  Created by Kirill Shalankin on 24/09/2019.
//  Copyright © 2019 Korablik. All rights reserved.
//

import Foundation

protocol MPLProductCardModuleConfigurator {
    func configureModule(id: String, name: String)
}

protocol MPLProductCardViewOutput {
    func viewDidLoad()
}

protocol MPLProductCardViewInput {
   func configure(product: APIResponse.Product)
}

protocol MPLProductCardInteractorOutput {
    func productDownloaded(product: APIResponse.Product)
}

protocol MPLProductCardInteractorInput {
    func downloadProduct(id: String)
}

protocol MPLProductCardRouterInput {

}

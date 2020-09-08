//
//  MPLProductCardInteractor.swift
//  Marketplace
//
//  Created by Kirill Shalankin on 24/09/2019.
//  Copyright © 2019 Korablik. All rights reserved.
//

import UIKit

class MPLProductCardInteractor: MPLBaseInteractor, MPLProductCardInteractorInput {

    // MARK: - Public vars & lets
    
    public var output: MPLProductCardInteractorOutput?
    
    
    // MARK: - Private vars & lets
    
    
    // MARK: - MPLProductCardInteractorInput

    func downloadProduct(id: String) {
        var params: [String: Any] = ["get_details" : "Y", "item_ids" : id]
        
        if let token = UserDefaults.standard.object(forKey: kMPLUserToken) {
            params["client_token"] = token
        }
        
        apiManager.call(type: RequestItemsType.productList,
                        params: params) {
            (res: Swift.Result<APIResponse.ProductList, AlertMessage>) in
            switch res {
            case .success(let list):
                self.output?.productDownloaded(product: list.products[0])
                break

            case .failure(let message):
                print(message.body)
                break
            }
        }
    }
}

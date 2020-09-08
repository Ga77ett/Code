//
//  MPLHomeInteractor.swift
//  Marketplace
//
//  Created by Kirill Shalankin on 17/06/2019.
//  Copyright © 2019 Korablik. All rights reserved.
//

import Foundation

class MPLHomeInteractor: MPLBaseInteractor, MPLHomeInteractorInput {
    
    // MARK: - Public vars & lets
    
    public var output: MPLHomeInteractorOutput?
    
    
    // MARK: - MPLHomeInteractorInput
    
    func downloadBanners(onMain: Bool) {
        let status = onMain ? "banner_on_main": "banner_product_list"
        apiManager.call(type: RequestItemsType.banners, params: ["status": "A", "sort_by": "position", "mobile_app_position": status]) {
            (res: Swift.Result<APIResponse.BannerList, AlertMessage>) in
                switch res {
                case .success(let banners):
                    self.output?.bannersWasDownloaded(banners: banners, main: onMain)
                    break
                    
                case .failure(let message):
                    print(message.body)
                    break
                }
        }
    }
    
    func downloadCatalog() {
        apiManager.call(type: RequestItemsType.categories, params: ["visible": "true", "get_images": "true",
                                                                    "sort_by": "position", "group_by_level": "true"]) {
            (res: Swift.Result<APIResponse.CategoriesList, AlertMessage>) in
                switch res {
                case .success(let categories):
                    self.output?.catalogWasDownloaded(catalog: categories)
                    break
                                                                            
                case .failure(let message):
                    print(message.body)
                    break
                }
        }
    }
    
    func downloadSpecialProducts(isSale: Bool) {
        let saleString = isSale ? "on_sale": "newest"
        let sortBy = isSale ? "popularity": "timestamp"
        
        var params: [String: Any] = ["type": saleString, "subcats": "Y", "status": "A",
                                     "sort_order": "desc", "sort_by": sortBy, "items_per_page": "20"]
        
        if let token = UserDefaults.standard.object(forKey: kMPLUserToken) {
            params["client_token"] = token
        }
        
        apiManager.call(type: RequestItemsType.specialProducts, params: params) {
            (res: Swift.Result<APIResponse.SpecialProducts, AlertMessage>) in
            switch res {
                case .success(let products):
                    self.output?.specialProductsWasDownloaded(products: products, isSale: isSale)
                break
            case .failure(let message):
                print(message.body)
                break
            }
        }
    }
    
    func downloadBrands() {
        apiManager.call(type: RequestItemsType.popularBrands, params: ["show_on_main": "Y"]) {
            (res: Swift.Result<APIResponse.BrandList, AlertMessage>) in
            switch res {
            case .success(let brands):
                self.output?.brandsWasDownloaded(brands: brands)
                break
                
            case .failure(let message):
                print(message.body)
                break
            }
        }
    }
    
    func favouritesAdd(id: String) {
        guard let token = UserDefaults.standard.object(forKey: kMPLUserToken) else {
            self.output?.needLoginFirst()
            return
        }
        apiManager.call(type: RequestItemsType.wishlistAdd,
                        params: ["client_token" : token,
                                 "product_data[\(id)][product_id]" : id]) {
                                    (res: Swift.Result<APIResponse.SimpleResponse, AlertMessage>) in
                                    switch res {
                                    case .success(let response):
                                        self.output?.favouritesAdded(added: response.errorCode == 0 ? true: false, message: response.errorMessage)
                                    case .failure(let message):
                                        print(message.body)
                                        break
                                    }
        }
    }
}

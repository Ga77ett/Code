//
//  MPLHomePresenter.swift
//  Marketplace
//
//  Created by Kirill Shalankin on 17/06/2019.
//  Copyright © 2019 Korablik. All rights reserved.
//

import Foundation

class MPLHomePresenter: NSObject, MPLHomeViewOutput, MPLHomeInteractorOutput {
    
    // MARK: - Public vars & lets
    
    public var view: MPLHomeViewInput?
    public var interactor: MPLHomeInteractorInput?
    public var router: MPLHomeRouterInput?
    
    
    // MARK: - MPLHomeViewOutput
    
    func viewDidLoad() {
        interactor?.downloadBanners(onMain: true)
        interactor?.downloadBanners(onMain: false)
        interactor?.downloadCatalog()
        interactor?.downloadSpecialProducts(isSale: true)
        interactor?.downloadSpecialProducts(isSale: false)
        interactor?.downloadBrands()
    }
    
    func openCatalog() {
        router?.showCatalog()
    }
    
    func popularCategoryTapped(id: String, name: String) {
        router?.showPopularProducts(id: id, name: name)
    }
    
    func specialProductsTapped(isSale: Bool) {
        router?.showSpecialProducts(isSale: isSale)
    }
    
    func brandsTapped(variantID: String, featureID: String, name: String) {
        router?.showBrands(variantID: variantID, featureID: featureID, name: name)
    }
    
    func searchTapped() {
        router?.showSearch()
    }
    
    func favouritesAdd(id: String) {
        interactor?.favouritesAdd(id: id)
    }
    
    func productTapped(id: String, name: String) {
        router?.showProductCard(id: id, name: name)
    }
    
    
    // MARK: - MPLHomeInteractorOutput
    
    func bannersWasDownloaded(banners: APIResponse.BannerList, main: Bool) {
        view?.setupSlider(banners: banners, main: main)
    }
    
    func catalogWasDownloaded(catalog: APIResponse.CategoriesList) {
        view?.setupCatalog(catalog: catalog)
    }
    
    func specialProductsWasDownloaded(products: APIResponse.SpecialProducts, isSale: Bool) {
        view?.setupSpecialProducts(products: products, isSale: isSale)
    }
    
    func brandsWasDownloaded(brands: APIResponse.BrandList) {
        view?.setupBrands(brands: brands)
    }
    
    func favouritesAdded(added: Bool, message: String?) {
        if !added {
            let errorView = MPLErrorMessage.instanceFromNib()
            errorView.show(message: message!)
        }
    }
    
    func needLoginFirst() {
        router?.showAuth()
    }
}

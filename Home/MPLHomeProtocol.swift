//
//  MPLHomeProtocol.swift
//  Marketplace
//
//  Created by Kirill Shalankin on 17/06/2019.
//  Copyright © 2019 Korablik. All rights reserved.
//

import Foundation

protocol MPLHomeViewOutput {
    func viewDidLoad()
    func openCatalog()
    func popularCategoryTapped(id: String, name: String)
    func specialProductsTapped(isSale: Bool)
    func brandsTapped(variantID: String, featureID: String, name: String)
    func searchTapped()
    func favouritesAdd(id: String)
    func productTapped(id: String, name: String)
}

protocol MPLHomeViewInput {
    func setupSlider(banners: APIResponse.BannerList, main: Bool)
    func setupCatalog(catalog: APIResponse.CategoriesList)
    func setupSpecialProducts(products: APIResponse.SpecialProducts, isSale: Bool)
    func setupBrands(brands: APIResponse.BrandList)
}

protocol MPLHomeInteractorOutput {
    func bannersWasDownloaded(banners: APIResponse.BannerList, main: Bool)
    func catalogWasDownloaded(catalog: APIResponse.CategoriesList)
    func specialProductsWasDownloaded(products: APIResponse.SpecialProducts, isSale: Bool)
    func brandsWasDownloaded(brands: APIResponse.BrandList)
    func favouritesAdded(added: Bool, message: String?)
    func needLoginFirst()
}

protocol MPLHomeInteractorInput {
    func downloadBanners(onMain: Bool)
    func downloadCatalog()
    func downloadSpecialProducts(isSale: Bool)
    func downloadBrands()
    func favouritesAdd(id: String)
}

protocol MPLHomeRouterInput {
    func showCatalog()
    func showPopularProducts(id: String, name: String)
    func showSpecialProducts(isSale: Bool)
    func showBrands(variantID: String, featureID: String, name: String)
    func showSearch()
    func showAuth()
    func showProductCard(id: String, name: String)
}

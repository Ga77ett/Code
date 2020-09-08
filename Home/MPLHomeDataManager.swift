//
//  MPLHomeDataManager.swift
//  Marketplace
//
//  Created by Kirill Shalankin on 17/06/2019.
//  Copyright © 2019 Korablik. All rights reserved.
//

import UIKit

enum MPLHomeDataManagerCellType: Int {
    case popularCategoriesHeader = 0
    case topCategories           = 1
    case newestHeader            = 2
    case newestProducts          = 3
    case banners                 = 4
    case saleHeader              = 5
    case saleProducts            = 6
    case brandsHeader            = 7
    case brands                  = 8
    case info                    = 9
    case feedback                = 10
}

/*
 switch MPLHomeDataManagerCellType(rawValue: indexPath.row) {
 case .popularCategoriesHeader?:
 
 default:
 }
 */

class MPLHomeDataManager: NSObject, UITableViewDelegate, UITableViewDataSource, MPLTopCategoriesCellOutput, MPLBrandsCarouselCellOutput, MPLListCellOutput {
    
    // MARK: - Public vars & lets
    
    public var view: MPLHomeViewController?
    
    var categories: APIResponse.CategoriesList?
    var saleProducts: APIResponse.SpecialProducts?
    var newestProducts: APIResponse.SpecialProducts?
    var brands: APIResponse.BrandList?
    var banners: APIResponse.BannerList?
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (banners?.banners.count ?? 0 > 0) {
            return 11
        }
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch MPLHomeDataManagerCellType(rawValue: modifiedIndex(indexPath: indexPath)) {
        case .popularCategoriesHeader?:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLLikeHeaderCell.cellIdentifier(), for: indexPath) as! MPLLikeHeaderCell
            cell.label.text = "Популярные категории"
            return cell
            
        case .topCategories?:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLTopCategoriesCell.cellIdentifier(), for: indexPath) as! MPLTopCategoriesCell
            guard let categories = categories else { return cell }
            cell.configure(categories: categories, output: self)
            return cell
            
        case .newestHeader?:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLLikeHeaderCell.cellIdentifier(), for: indexPath) as! MPLLikeHeaderCell
            cell.label.text = "Новинки"
            return cell
            
        case .newestProducts?:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLProductCarouselCell.cellIdentifier(), for: indexPath) as! MPLProductCarouselCell
            guard let products = newestProducts else { return cell }
            cell.configure(products: products, output: self)
            return cell
            
        case .banners?:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLBannersCell.cellIdentifier(), for: indexPath) as! MPLBannersCell
            guard let banners = banners else { return cell }
            cell.configure(banners: banners)
            return cell
            
        case .saleHeader?:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLLikeHeaderCell.cellIdentifier(), for: indexPath) as! MPLLikeHeaderCell
            cell.label.text = "Распродажа"
            return cell
            
        case .saleProducts?:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLProductCarouselCell.cellIdentifier(), for: indexPath) as! MPLProductCarouselCell
            guard let products = saleProducts else { return cell }
            cell.configure(products: products, output: self)
            return cell
            
        case .brandsHeader?:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLLikeHeaderCell.cellIdentifier(), for: indexPath) as! MPLLikeHeaderCell
            cell.label.text = "Популярные бренды"
            return cell
            
        case .brands?:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLBrandsCarouselCell.cellIdentifier(), for: indexPath) as! MPLBrandsCarouselCell
            guard let brands = brands else { return cell }
            cell.configure(brands: brands, output: self)
            return cell
            
        case .info?:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLInfoCell.cellIdentifier(), for: indexPath) as! MPLInfoCell
            cell.configure(type: .info)
            return cell
            
        case .feedback?:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLInfoCell.cellIdentifier(), for: indexPath) as! MPLInfoCell
            cell.configure(type: .feedback)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch MPLHomeDataManagerCellType(rawValue: modifiedIndex(indexPath: indexPath)) {
        case .popularCategoriesHeader?:
            view?.output?.openCatalog()
        case .newestHeader?:
            view?.output?.specialProductsTapped(isSale: false)
        case .saleHeader?:
            view?.output?.specialProductsTapped(isSale: true)
            
        default: break
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch MPLHomeDataManagerCellType(rawValue: modifiedIndex(indexPath: indexPath)) {
        case .popularCategoriesHeader?, .newestHeader?, .saleHeader?, .brandsHeader?:
            return MPLLikeHeaderCell.cellHeight()
            
        case .topCategories?:
            return MPLTopCategoriesCell.cellHeight()
            
        case .newestProducts?, .saleProducts?:
            return MPLProductCarouselCell.cellHeight()
            
        case .banners?:
            return MPLBannersCell.cellHeight()
            
        case .brands?:
            return MPLBrandsCarouselCell.cellHeight()
            
        case .feedback?, .info?:
            return MPLInfoCell.cellHeight()
            
        default:
            return 0
        }
    }
    
    private func modifiedIndex(indexPath: IndexPath) -> Int {
        var index = indexPath.row
        
        if (banners?.banners.count ?? 0 == 0 && index >= MPLHomeDataManagerCellType.banners.rawValue) {
            index += 1
        }
        
        return index
    }
    
    
    // MARK: - MPLTopCategoriesCellOutput
    
    func popularCategoryTapped(id: String, name: String) {
        view?.output?.popularCategoryTapped(id: id, name: name)
    }
    
    
    // MARK: - MPLBrandsCarouselCellOutput
    
    func brandsTapped(variantID: String, featureID: String, name: String) {
        view?.output?.brandsTapped(variantID: variantID, featureID: featureID, name: name)
    }
    
    
    // MARK: - MPLListCellOutput
    
    func favourites(id: String) {
        view?.output?.favouritesAdd(id: id)
    }

    func productTapped(id: String, name: String) {
        view?.output?.productTapped(id: id, name: name)
    }
}

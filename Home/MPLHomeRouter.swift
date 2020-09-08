//
//  MPLHomeRouter.swift
//  Marketplace
//
//  Created by Kirill Shalankin on 17/06/2019.
//  Copyright © 2019 Korablik. All rights reserved.
//

import UIKit

class MPLHomeRouter: MPLBaseRouter, MPLHomeRouterInput {
    
    // MARK: - MPLHomeRouterInput
    
    func showCatalog() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else { return }
            if let tabBarController = window.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 1
            }
        }
    }
    
    func showPopularProducts(id: String, name: String) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MPLProductListViewController") as! MPLProductListViewController
            let presenter = controller.output as! MPLProductListPresenter
            presenter.configureModule(id: id, listName: name, type: .popularProducts)
            //let navVC = UINavigationController.init(rootViewController: controller)
            self.view?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func showSpecialProducts(isSale: Bool) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MPLProductListViewController") as! MPLProductListViewController
            let presenter = controller.output as! MPLProductListPresenter
            if isSale {
                presenter.configureModule(id: "", listName: "Распродажа", type: .saleProducts)
                
            } else {
                presenter.configureModule(id: "", listName: "Новинки", type: .newestProducts)
            }
            
            self.view?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func showBrands(variantID: String, featureID: String, name: String) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MPLProductListViewController") as! MPLProductListViewController
            let presenter = controller.output as! MPLProductListPresenter
            presenter.configureBrandsModule(variantID: variantID, featureID: featureID, listName: name)
            
            self.view?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func showSearch() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MPLSearchViewController") as! MPLSearchViewController
            
            self.view?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func showAuth() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Authorization", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MPLAuthViewController") as! MPLAuthViewController
            let navVC = UINavigationController.init(rootViewController: controller)
            
            self.view?.navigationController?.present(navVC, animated: true, completion: nil)
        }
    }
    
    func showProductCard(id: String, name: String) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MPLProductCardViewController")
                as! MPLProductCardViewController
            let presenter = controller.output as! MPLProductCardPresenter
            presenter.configureModule(id: id, name: name)
            //let navVC = UINavigationController.init(rootViewController: controller)
            self.view?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

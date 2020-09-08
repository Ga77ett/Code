//
//  MPLProductCardDataManager.swift
//  Marketplace
//
//  Created by Kirill Shalankin on 24/09/2019.
//  Copyright © 2019 Korablik. All rights reserved.
//

import UIKit

enum MPLProductCardDataManagerCellType: Int {
    case productCarousel      = 0
    case productInfo          = 1
    case description          = 2
    case orderButtons         = 3
    case specification        = 4
    case shortCharacteristics = 5
    case map                  = 6
}

class MPLProductCardDataManager: NSObject, UITableViewDelegate, UITableViewDataSource, MPLDescriptionCellOutput {

    // MARK: - Public vars & lets
    
    public var view: MPLProductCardViewController?
    
    
    // MARK: - Private vars & lets
    
    private var product: APIResponse.Product?
    private var collapsed: Bool = true
    
    
    // MARK: - Init
    
    func configure(product: APIResponse.Product) {
        self.product = product
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product == nil ? 0 : 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch MPLProductCardDataManagerCellType(rawValue: indexPath.row) {
        case .productCarousel?:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLImageCarouselCell.cellIdentifier(),
                                                     for: indexPath) as! MPLImageCarouselCell
            guard let images = product?.images else { return cell }
            cell.configure(images: images, disc: product?.discount)
            return cell
            
        case .productInfo?:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLProductInfoCell.cellIdentifier(),
                                                     for: indexPath) as! MPLProductInfoCell
            guard let product = product else { return cell }
            cell.configure(product: product)
            return cell
            
        case .description?:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLDescriptionCell.cellIdentifier(),
                                                     for: indexPath) as! MPLDescriptionCell
            guard let desc = product?.description else { return cell }
            cell.configure(text: desc, collapsed: collapsed)
            cell.output = self
            return cell
            
        case .orderButtons?:
            if product?.subtype == "advert" {
                let cell = tableView.dequeueReusableCell(withIdentifier: MPLAdvertOrderButtonsCell.cellIdentifier(),
                                                         for: indexPath) as! MPLAdvertOrderButtonsCell

                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: MPLOrderButtonsCell.cellIdentifier(),
                                                         for: indexPath) as! MPLOrderButtonsCell

                return cell
            }
            
        case .specification?:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLInfoCell.cellIdentifier(),
                                                     for: indexPath) as! MPLInfoCell
            cell.configure(type: .specification)
            return cell
            
        case .shortCharacteristics?:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLShortCharacteristicsCell.cellIdentifier(),
                                                     for: indexPath) as! MPLShortCharacteristicsCell
            guard let product = product else { return cell }
            let advert = product.subtype == "advert" ? true : false
            cell.configure(topText: product.categoryName,
                           centerText: advert ? product.sellerName! : product.companyName!,
                           bottomText: advert ? product.timestamp : product.productCode!,
                           type: advert ? .advert : .product)
            return cell
            
        case .map?:
            let cell = tableView.dequeueReusableCell(withIdentifier: MPLMapCell.cellIdentifier(),
                                                     for: indexPath) as! MPLMapCell
            guard let product = product else { return cell }
            cell.configure(latitude: product.latitude ?? 0.0,
                           longitude: product.longitude ?? 0.0,
                           address: product.address ?? "",
                           city: product.cityName ?? "")
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch MPLProductCardDataManagerCellType(rawValue: indexPath.row) {
        case .productCarousel?, .productInfo?, .description?, .orderButtons?, .map?:
            return UITableView.automaticDimension
            
        case .specification?:
            return MPLInfoCell.cellHeight()
            
        case .shortCharacteristics:
            return MPLShortCharacteristicsCell.cellHeight()
            
        default:
            return 0
        }
    }
    
    
    // MARK: - MPLDescriptionCellOutput
    
    func needToReloadTable() {
        collapsed = !collapsed
        view?.tableView.reloadRows(at: [IndexPath.init(row: MPLProductCardDataManagerCellType.description.rawValue,
                                                       section: 0)], with: .none)
    }
}

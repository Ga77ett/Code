//
//  MPLHomeViewController.swift
//  Marketplace
//
//  Created by Kirill Shalankin on 17/06/2019.
//  Copyright © 2019 Korablik. All rights reserved.
//

import UIKit

class MPLHomeViewController: UITableViewController, MPLHomeViewInput {
    
    // MARK: - Public vars & lets
    
    public var output: MPLHomeViewOutput?
    public var dataManager: MPLHomeDataManager?
    
    @IBOutlet var paralaxTableView: MPLParalaxTableView!
    
    
    // MARK: - Private vars & lets
    
    
    // MARK: - Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        MPLHomeAssembly.createModule(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        output?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    // MARK: - Setup
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupInitialState() {
        setupTableView()
    }
    
    private func setupTableView() {
        paralaxTableView.register(UINib(nibName: MPLLikeHeaderCell.cellNibName(), bundle: nil),
                                  forCellReuseIdentifier: MPLLikeHeaderCell.cellIdentifier())
        paralaxTableView.register(UINib(nibName: MPLProductCarouselCell.cellNibName(), bundle: nil),
                                  forCellReuseIdentifier: MPLProductCarouselCell.cellIdentifier())
        paralaxTableView.register(UINib(nibName: MPLBrandsCarouselCell.cellNibName(), bundle: nil),
                                  forCellReuseIdentifier: MPLBrandsCarouselCell.cellIdentifier())
        paralaxTableView.register(UINib(nibName: MPLBannersCell.cellNibName(), bundle: nil),
                                  forCellReuseIdentifier: MPLBannersCell.cellIdentifier())
        paralaxTableView.register(UINib(nibName: MPLTopCategoriesCell.cellNibName(), bundle: nil),
                                  forCellReuseIdentifier: MPLTopCategoriesCell.cellIdentifier())
        paralaxTableView.register(UINib(nibName: MPLInfoCell.cellNibName(), bundle: nil),
                                  forCellReuseIdentifier: MPLInfoCell.cellIdentifier())
        
        paralaxTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        paralaxTableView.delegate = dataManager
        paralaxTableView.dataSource = dataManager
        
        guard let header = paralaxTableView.tableHeaderView else { return }
        if let sliderView = header.subviews.first {
            let heightConstraint = sliderView.constraints.filter{ $0.identifier == "heightConstraint" }.first
            heightConstraint?.constant = view.frame.size.height / 3
        }
        
        paralaxTableView.searchButton.addTarget(self, action: #selector(searchAction), for: .touchDown)
    }
    
    @objc func searchAction() {
        output?.searchTapped()
    }
    
    
    // MARK: - MPLHomeViewInput
    
    func setupSlider(banners: APIResponse.BannerList, main: Bool) {
        if main {
            paralaxTableView.configureSlider(banners: banners)
            
        } else {
            dataManager?.banners = banners
            paralaxTableView.reloadData()
        }
    }
    
    func setupCatalog(catalog: APIResponse.CategoriesList) {
        dataManager?.categories = catalog
        paralaxTableView.reloadData()
    }
    
    func setupSpecialProducts(products: APIResponse.SpecialProducts, isSale: Bool) {
        if isSale {
            dataManager?.saleProducts = products
            
        } else {
            dataManager?.newestProducts = products
        }
        
        paralaxTableView.reloadData()
    }
    
    func setupBrands(brands: APIResponse.BrandList) {
        dataManager?.brands = brands
        paralaxTableView.reloadData()
    }
}

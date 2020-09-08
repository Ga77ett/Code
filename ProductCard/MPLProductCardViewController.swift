//
//  MPLProductCardViewController.swift
//  Marketplace
//
//  Created by Kirill Shalankin on 24/09/2019.
//  Copyright © 2019 Korablik. All rights reserved.
//

import UIKit

class MPLProductCardViewController: UIViewController, MPLProductCardViewInput  {
    
    // MARK: - Public vars & lets
    
    public var output: MPLProductCardViewOutput?
    public var dataManager: MPLProductCardDataManager?
    
    
    // MARK: - Private vars & lets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        MPLProductCardAssembly.createModule(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        setupInitialState()
        output?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupInitialState() {
        setupTableView()
        setupNavButtons()
    }
    
    private func setupTableView() {
        tableView.delegate = dataManager
        tableView.dataSource = dataManager
        tableView.register(UINib(nibName: MPLImageCarouselCell.cellNibName(), bundle: nil),
                           forCellReuseIdentifier: MPLImageCarouselCell.cellIdentifier())
        tableView.register(UINib(nibName: MPLProductInfoCell.cellNibName(), bundle: nil),
                           forCellReuseIdentifier: MPLProductInfoCell.cellIdentifier())
        tableView.register(UINib(nibName: MPLDescriptionCell.cellNibName(), bundle: nil),
                           forCellReuseIdentifier: MPLDescriptionCell.cellIdentifier())
        tableView.register(UINib(nibName: MPLOrderButtonsCell.cellNibName(), bundle: nil),
                           forCellReuseIdentifier: MPLOrderButtonsCell.cellIdentifier())
        tableView.register(UINib(nibName: MPLAdvertOrderButtonsCell.cellNibName(), bundle: nil),
                           forCellReuseIdentifier: MPLAdvertOrderButtonsCell.cellIdentifier())
        tableView.register(UINib(nibName: MPLInfoCell.cellNibName(), bundle: nil),
                           forCellReuseIdentifier: MPLInfoCell.cellIdentifier())
        tableView.register(UINib(nibName: MPLShortCharacteristicsCell.cellNibName(), bundle: nil),
                           forCellReuseIdentifier: MPLShortCharacteristicsCell.cellIdentifier())
        tableView.register(UINib(nibName: MPLMapCell.cellNibName(), bundle: nil),
                           forCellReuseIdentifier: MPLMapCell.cellIdentifier())
        
        tableView.rowHeight = MPLProductInfoCell.cellHeight()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }
    
    private func setupNavButtons() {
        let shareButton = UIButton(type: .custom)
        shareButton.frame = CGRect(x:0, y:0, width: 45, height:45)
        shareButton.setImage(UIImage(named: "Share_icon"), for: .normal)
        shareButton.setImage(UIImage(named: "Share_icon"), for: .highlighted)
        let barButtonItem = UIBarButtonItem.init(customView: shareButton)
        
        let favButton = UIButton(type: .custom)
        favButton.frame = CGRect(x:0, y:0, width: 45, height:45)
        favButton.setImage(UIImage(named: "Fav_icon"), for: .normal)
        favButton.setImage(UIImage(named: "Fav_icon"), for: .highlighted)
        let barButtonItem2 = UIBarButtonItem.init(customView: favButton)
        
        //searchButton.addTarget(self, action: #selector(self.searchAction), for: .touchDown)
        navigationItem.rightBarButtonItems = [barButtonItem2, barButtonItem]
    }
    
    
    // MARK: - MPLProductCardViewInput
    
    func configure(product: APIResponse.Product) {
        dataManager?.configure(product: product)
        tableView.reloadData()
    }
    
}

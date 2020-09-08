//
//  KBLProductCardViewController.m
//  Korablik
//
//  Created by Kirill Shalankin on 16/08/2017.
//  Copyright © 2017 Kirill Shalankin. All rights reserved.
//

#import "KBLProductCardViewController.h"
#import "KBLCartButton.h"
#import "KBLNewProductCard.h"
#import "KBLAppearance.h"

@interface KBLProductCardViewController ()

@property (strong, nonatomic) NSString *productName;

@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UIButton *addToBasketButton;


- (IBAction)addToCartAction:(id)sender;

@end

@implementation KBLProductCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitialState];
    [self.output viewDidReady];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTitle:self.productName];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
}

- (void)setupInitialState {
    [self setupTableView];
    [self setupRightButtons];
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    [self.priceView setAlpha:0.f];
}

#pragma mark - Setup

- (void)setupTableView {
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.estimatedRowHeight = 277.f;
    
    [self.tableView registerNib:[UINib nibWithNibName:[KBLProductPreviewTableViewCell nibName]
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:[KBLProductPreviewTableViewCell cellReuseIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[KBLProductCarouselCell nibName]
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:[KBLProductCarouselCell cellReuseIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[KBLProductDescriptionCell nibName]
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:[KBLProductDescriptionCell cellReuseIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[KBLOrderButtonsCell nibName]
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:[KBLOrderButtonsCell cellReuseIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[KBLObtainingCell nibName]
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:[KBLObtainingCell cellReuseIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[KBLDescriptionWithNumberCell nibName]
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:[KBLDescriptionWithNumberCell cellReuseIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[KBLSizeCell nibName]
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:[KBLSizeCell cellReuseIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[KBLProductCardPromoCell nibName]
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:[KBLProductCardPromoCell cellReuseIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[KBLColorCell nibName]
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:[KBLColorCell cellReuseIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[KBLHeaderCell nibName]
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:[KBLHeaderCell cellReuseIdentifier]];
}

- (void)setupRightButtons {
    KBLCartButton *cart = [[KBLCartButton alloc] init];
    [cart addTarget:self.output action:@selector(cartDidTapped) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:cart];
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Share"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(shareAction)];
    [self.navigationItem setRightBarButtonItems:@[item, share]];
}

#pragma mark - KBLProductCardViewInput

- (void)setupTitle:(NSString *)title {
    [self.navigationItem setTitle:title];
    self.productName = title;
}

- (void)configureWithData:(KBLNewProductCard *)data {
    [self.dataManager configureWithData:data];
    
    self.tableView.delegate = self.dataManager;
    self.tableView.dataSource = self.dataManager;
    [self.tableView reloadData];
    
    NSString *priceString = [NSString stringWithFormat:@"В корзину ● %g ₽", data.currentPrice];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:priceString
                                                   attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f
                                                                                                       weight:UIFontWeightMedium],
                                                                NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                NSKernAttributeName:@(-0.32)}];
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:12.f] range:NSMakeRange(10, 1)];
    
    [self.addToBasketButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    if (!self.productName.length) {
        [self setupTitle:data.productName];
    }
}

- (void)configureAccessoriesProducts:(NSArray *)products {
    [self.dataManager setSimilarProducts:products];
    [self.tableView reloadData];
}

- (void)updateReviewsCount:(NSArray *)reviews {
    [self.dataManager updateReviews:reviews];
    [self.tableView reloadData];
}

- (void)configureProductsBlock:(NSArray *)products {
    [self.dataManager setProductsBlock:products];
    [self.tableView reloadData];
}

- (void)reloadCellWichContainsProduct:(id)product {
    [self.dataManager reloadCellWithProduct:product];
}

#pragma mark - Actions

- (void)shareAction {
    NSString *string = self.productName;
    NSURL *URL = [NSURL URLWithString:[self.dataManager getProductURLString]];
    
    if (string && URL) {
        UIActivityViewController *activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:@[string, URL]
                                          applicationActivities:nil];
        
        [self presentViewController:activityViewController
                           animated:YES
                         completion:^{
                             [activityViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
                         }];
    }
}

- (void)priceViewNeedToHide:(BOOL)hide {
    if (hide) {
        if (!self.priceView.isHidden) {
            [UIView animateWithDuration:0.5 animations:^{
                [self.priceView setAlpha:0.f];
                [self.tableView setContentInset:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)];
                
            } completion:^(BOOL finished) {
                [self.priceView setHidden:YES];
            }];
        }
        
    } else {
        if (self.priceView.isHidden) {
            [self.priceView setHidden:NO];
            
            [UIView animateWithDuration:0.5 animations:^{
                [self.priceView setAlpha:1.f];
                [self.tableView setContentInset:UIEdgeInsetsMake(0.f, 0.f, self.priceView.frame.size.height + 10.f, 0.f)];
            }];
        }
    }
}

- (IBAction)addToCartAction:(id)sender {
    [self.dataManager.addToCartButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end

//
//  KBLProductCardDataManager.h
//  Korablik
//
//  Created by Kirill Shalankin on 16/08/2017.
//  Copyright © 2017 Kirill Shalankin. All rights reserved.
//

#import "KBLDataManager.h"
#import "KBLProductCardViewController.h"
#import "KBLProductPreviewTableViewCell.h"
#import "KBLProductCarouselCell.h"
#import "KBLProductDescriptionCell.h"
#import "KBLOrderButtonsCell.h"
#import "KBLObtainingCell.h"
#import "KBLSizeCell.h"
#import "KBLDescriptionWithNumberCell.h"
#import "KBLProductCardPromoCell.h"
#import "KBLColorCell.h"
#import "KBLHeaderCell.h"

@class KBLProductCardViewController;

@interface KBLProductCardDataManager : KBLDataManager

@property (weak, nonatomic) KBLProductCardViewController *view;
@property (weak, nonatomic) UIButton *addToCartButton;

- (void)configureWithData:(id)data;
- (void)updateReviews:(NSArray *)reviews;
- (NSString *)getProductURLString;
- (void)setProductsBlock:(NSArray *)products;
- (void)setSimilarProducts:(NSArray *)products;
- (void)reloadCellWithProduct:(id)product;

@end

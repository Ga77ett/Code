//
//  KBLProductCardModel.h
//  Korablik
//
//  Created by Kirill Shalankin on 08/09/2017.
//  Copyright © 2017 Kirill Shalankin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KBLProductPreviewModel.h"

@interface KBLProductCardModel : NSObject

@property (strong, nonatomic) KBLProductPreviewModel *previewModel;
@property (strong, nonatomic) NSString *vendorCode;
@property (strong, nonatomic) NSMutableArray *imageURLs;
@property (strong, nonatomic) NSArray *sizes;
@property (assign, nonatomic) CGFloat rating;
@property (strong, nonatomic) NSString *link;
@property (assign, nonatomic) BOOL isApparel;
@property (strong, nonatomic) NSString *productDescription;
@property (assign, nonatomic) CGFloat monthFrom;
@property (assign, nonatomic) CGFloat monthTo;
@property (strong, nonatomic) NSString *dimensions;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *manufacture;
@property (strong, nonatomic) NSString *manufactureVendorCode;
@property (strong, nonatomic) NSString *materials;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSMutableArray *storepickupIDs;
@property (assign, nonatomic) BOOL isDelivered;
@property (strong, nonatomic) NSString *selectedSize;
@property (strong, nonatomic) NSMutableArray <NSString *>*videoURLs;

@end

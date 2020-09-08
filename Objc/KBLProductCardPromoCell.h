//
//  KBLProductCardPromoCell.h
//  Korablik
//
//  Created by Kirill Shalankin on 11/04/2019.
//  Copyright © 2019 Kirill Shalankin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KBLProductCardPromoCell : UITableViewCell

+ (NSString *)cellReuseIdentifier;
+ (NSString *)nibName;
+ (CGFloat)cellHeight;

- (void)configureWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END

//
//  KBLProductCardPromoCell.m
//  Korablik
//
//  Created by Kirill Shalankin on 11/04/2019.
//  Copyright © 2019 Kirill Shalankin. All rights reserved.
//

#import "KBLProductCardPromoCell.h"
#import "KBLAppearance.h"

@interface KBLProductCardPromoCell ()

@property (weak, nonatomic) IBOutlet UIView *promoView;
@property (weak, nonatomic) IBOutlet UILabel *promoLabel;

@end

static NSString *const kKBLProductCardPromoIdentifier  = @"KBLProductCardPromoCellIdentifier";
static NSString *const kKBLProductCardPromoNibName     = @"KBLProductCardPromoCell";
static CGFloat const kKBLProductCardPromoHeight        = 30.f;

@implementation KBLProductCardPromoCell

+ (NSString *)cellReuseIdentifier {
    return kKBLProductCardPromoIdentifier;
}

+ (NSString *)nibName {
    return kKBLProductCardPromoNibName;
}

+ (CGFloat)cellHeight {
    return kKBLProductCardPromoHeight;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureWithText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:[NSString stringWithFormat:@"Акция: %@", text]
                                                   attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f weight:UIFontWeightRegular], NSForegroundColorAttributeName: [UIColor blackColor], NSKernAttributeName: @(-0.15) }];
    [attributedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f weight:UIFontWeightRegular],
                                      NSForegroundColorAttributeName: [KBLAppearance pumpkinOrangeColor]} range:NSMakeRange(0, 6)];
    [self.promoLabel setAttributedText:attributedString];
}

- (void)drawRect:(CGRect)rect {
    CAShapeLayer *yourViewBorder = [CAShapeLayer layer];
    yourViewBorder.strokeColor = [KBLAppearance ki_redColor].CGColor;
    yourViewBorder.fillColor = nil;
    yourViewBorder.lineDashPattern = @[@2, @2];
    yourViewBorder.frame = self.promoView.bounds;
    yourViewBorder.path = [UIBezierPath bezierPathWithRect:self.promoView.bounds].CGPath;
    [self.promoView.layer addSublayer:yourViewBorder];
}

@end

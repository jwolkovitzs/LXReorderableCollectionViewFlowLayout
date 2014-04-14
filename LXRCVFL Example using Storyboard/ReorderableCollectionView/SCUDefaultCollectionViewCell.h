//
//  SCUDefaultCollectionViewCell.h
//  SavantController
//
//  Created by Nathan Trapp on 4/8/14.
//  Copyright (c) 2014 Savant Systems. All rights reserved.
//

//@import UIKit;
#import <UIKit/UIKit.h>

extern NSString *const SCUDefaultCollectionViewCellKeyTitle;
extern NSString *const SCUDefaultCollectionViewCellKeyModelObject;

@protocol SCUCollectionViewCellDeleteButtonDelegate <NSObject>

- (void)removeCell:(UICollectionViewCell *)cell;

@end

@interface SCUDefaultCollectionViewCell : UICollectionViewCell

@property (readonly) UILabel *textLabel;
@property (nonatomic) CGSize deleteButtonSize;
@property (strong, nonatomic) NSString *deleteButtonImageName;
@property (weak, nonatomic) id<SCUCollectionViewCellDeleteButtonDelegate> delegate;

- (void)configureWithInfo:(NSDictionary *)info;
- (void)showDeleteButton:(BOOL)show;

@end
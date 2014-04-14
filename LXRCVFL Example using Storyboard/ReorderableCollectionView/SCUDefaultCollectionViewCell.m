//
//  SCUDefaultCollectionViewCell.m
//  SavantController
//
//  Created by Nathan Trapp on 4/8/14.
//  Copyright (c) 2014 Savant Systems. All rights reserved.
//

#import "SCUDefaultCollectionViewCell.h"

NSString *const SCUDefaultCollectionViewCellKeyTitle = @"SCUDefaultCollectionViewCellKeyTitle";
NSString *const SCUDefaultCollectionViewCellKeyModelObject = @"SCUDefaultCollectionViewCellKeyModelObject";
static NSString *defualtDeleteButtonImageName = @"defualtDeleteBotton.png";

static int defualtDeleteButtonSize = 30;

@interface SCUDefaultCollectionViewCell ()

@property UILabel *textLabel;

@property (strong, nonatomic) UIButton *deleteButton;

- (void)deleteButtonPushed:(id)sender;

@end

@implementation SCUDefaultCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.textLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.textLabel];
        self.textLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configureWithInfo:(NSDictionary *)info
{
    self.textLabel.text = info[SCUDefaultCollectionViewCellKeyTitle];
}

- (void)addDeleteButton
{
    if (!self.deleteButton)
    {
        if (self.deleteButtonSize.width < 1)
        {
            self.deleteButtonSize = CGSizeMake(defualtDeleteButtonSize, defualtDeleteButtonSize);
        }
        if (!self.deleteButtonImageName)
        {
            self.deleteButtonImageName = defualtDeleteButtonImageName;
        }
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setFrame:CGRectMake(self.frame.size.width - (self.deleteButtonSize.width), // * 3 / 4 ),
                                               0, //- (self.deleteButtonSize.height / 4),
                                               self.deleteButtonSize.width,
                                               self.deleteButtonSize.height)];
        [self.deleteButton addTarget:self action:@selector(deleteButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *sss = [UIImage imageNamed:self.deleteButtonImageName];
        [self.deleteButton setImage:sss forState:UIControlStateNormal];
        self.deleteButton.clipsToBounds = NO;
        self.clipsToBounds = NO;
        [self addSubview:self.deleteButton];
    }
}

- (void)showDeleteButton:(BOOL)show
{
    if (show)
    {
        if (!self.deleteButton)
        {
            [self addDeleteButton];
            [self.deleteButton setEnabled:YES];
        }
        self.deleteButton.hidden = NO;
    }
    else
    {
        if (self.deleteButton)
        {
            self.deleteButton.hidden = YES;
        }
    }
}

- (void)deleteButtonPushed:(id)sender
{
    [self.delegate removeCell:self];
}

@end

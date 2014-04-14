//
//  PlayingCardCell.h
//  LXRCVFL Example using Storyboard
//
//  Created by Stan Chang Khin Boon on 3/10/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUDefaultCollectionViewCell.h"

@class PlayingCard;

@interface PlayingCardCell : SCUDefaultCollectionViewCell

@property (strong, nonatomic) PlayingCard *playingCard;
@property (strong, nonatomic) IBOutlet UIImageView *playingCardImageView;

@end

//
//  LXCollectionViewController.h
//  LXRCVFL Example using Storyboard
//
//  Created by Stan Chang Khin Boon on 3/10/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUReorderableCollectionViewFlowLayout.h"
#import "SCUCollectionViewController.h"
@interface LXCollectionViewController : SCUCollectionViewController <SCUReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *deck;

@end

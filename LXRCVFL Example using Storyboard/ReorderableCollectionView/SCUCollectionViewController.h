//
//  SCUCollectionViewController.h
//
//  Created by Jason Wolkovitz on 4/13/14.
//

#import <UIKit/UIKit.h>
//@import UIKit;
#import "SCUReorderableCollectionViewFlowLayout.h"

@interface SCUCollectionViewController : UICollectionViewController <SCUReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>

@property (nonatomic) BOOL isInEditMode;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

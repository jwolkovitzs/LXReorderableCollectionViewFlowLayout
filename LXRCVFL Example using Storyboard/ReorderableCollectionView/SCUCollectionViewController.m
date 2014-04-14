//
//  SCUCollectionViewController.m
//
//  Created by Jason Wolkovitz on 4/13/14.
//

#import "SCUCollectionViewController.h"

@interface SCUCollectionViewController ()

@end

@implementation SCUCollectionViewController

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [((SCUReorderableCollectionViewFlowLayout *)self.collectionViewLayout) setEditing:self.isInEditMode];
}

@end

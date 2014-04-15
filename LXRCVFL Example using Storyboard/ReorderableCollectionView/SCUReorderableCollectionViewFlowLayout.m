//
//  SCUReorderableCollectionViewFlowLayout.m
//
//  Created by Jason Wolkovitz on 4/10/14.
//

#import "SCUReorderableCollectionViewFlowLayout.h"
#import "LXReorderableCollectionViewFlowLayoutPrivate.h"

@interface SCUReorderableCollectionViewFlowLayout ()
@property UICollectionViewCell *selectedCell;
@property (assign, nonatomic) id<SCUReorderableCollectionViewDataSource> dataSource;
@property (assign, nonatomic) id<LXReorderableCollectionViewDelegateFlowLayout> delegate;
@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

- (id<SCUReorderableCollectionViewDataSource>)dataSource;
- (id<LXReorderableCollectionViewDelegateFlowLayout>)delegate;

@end

@implementation SCUReorderableCollectionViewFlowLayout

@synthesize panGestureRecognizer = _panGestureRecognizer;

#pragma mark - overRide setupCollecitonView to setup differnt GestureRecognizer
- (void)setupCollectionView
{
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(handlePanGesture:)];
    self.panGestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:self.panGestureRecognizer];
    
    // Useful in multiple scenarios: one common scenario being when the Notification Center drawer is pulled down
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    if ([layoutAttributes.indexPath isEqual:self.selectedItemIndexPath])
    {
        if (self.collectionViewMovingItemPlaceholderView)
        {
            UICollectionViewCell *collectionViewCell = [self.collectionView cellForItemAtIndexPath:self.selectedItemIndexPath];
            
            [self.collectionViewMovingItemPlaceholderView setFrame:CGRectMake(0, 0, collectionViewCell.frame.size.width, collectionViewCell.frame.size.height)] ;
            [collectionViewCell addSubview:self.collectionViewMovingItemPlaceholderView];
            
            NSLog(@"%@", [NSValue valueWithCGRect: self.collectionViewMovingItemPlaceholderView.frame]);
        }
        else
        {
            [super applyLayoutAttributes:layoutAttributes];
        }
    }
}

- (void)removeHiddenCells
{
    NSArray *subViews = [self.collectionView subviews];
    for (UIView *aView in subViews)
    {
        if ([aView isKindOfClass:[UICollectionViewCell class]])
        {
            if (aView.hidden)
            {
                [aView removeFromSuperview];
            }
            else if ((int)aView.alpha == 0)
            {
                [aView removeFromSuperview];
            }
        }
    }
}

#pragma mark - SCUCollectionViewCellDeleteButtonDelegate methods

- (void)removeCell:(UICollectionViewCell *)cell
{
    if ([self.dataSource respondsToSelector:@selector(collectionView:commitEditingStyle:forItemAtIndexPath:)])
    {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        [self.dataSource collectionView:self.collectionView commitEditingStyle:SCUCollectionViewItemEditingStyleDelete forItemAtIndexPath:indexPath];
    }
}

#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([self.panGestureRecognizer isEqual:gestureRecognizer] && self.isEditing)
    {
        return YES;
    }
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        return YES;
    }
    return NO;
}

- (void)touchesBegan:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)] &&
        ![self.dataSource collectionView:self.collectionView canMoveItemAtIndexPath:indexPath])
    {
        return;
    }
    
    self.selectedItemIndexPath = indexPath;
    
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:willBeginDraggingItemAtIndexPath:)])
    {
        [self.delegate collectionView:self.collectionView layout:self willBeginDraggingItemAtIndexPath:self.selectedItemIndexPath];
    }
    
    UICollectionViewCell *collectionViewCell = [self.collectionView cellForItemAtIndexPath:self.selectedItemIndexPath];
    
    self.currentView = [[UIView alloc] initWithFrame:collectionViewCell.frame];
    
    
    collectionViewCell.highlighted = YES;
    UIImageView *highlightedImageView = [[UIImageView alloc] initWithImage:[collectionViewCell LX_rasterizedImage]];
    highlightedImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    highlightedImageView.alpha = 1.0f;
    
    collectionViewCell.highlighted = NO;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[collectionViewCell LX_rasterizedImage]];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.alpha = 0.0f;
    
    [self.currentView addSubview:imageView];
    [self.currentView addSubview:highlightedImageView];
    [self.collectionView addSubview:self.currentView];
    
    self.currentViewCenter = self.currentView.center;
    
    [UIView
     animateWithDuration:0.3
     delay:0.0
     options:UIViewAnimationOptionBeginFromCurrentState
     animations:^{
         self.currentView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
         
         highlightedImageView.alpha = 0.0f;
         imageView.alpha = 1.0f;
         
     }
     completion:^(BOOL finished) {
         [highlightedImageView removeFromSuperview];
         
         if ([self.delegate respondsToSelector:@selector(collectionView:layout:didBeginDraggingItemAtIndexPath:)])
         {
             [self.delegate collectionView:self.collectionView layout:self didBeginDraggingItemAtIndexPath:self.selectedItemIndexPath];
         }
     }];
    [self invalidateLayout];
}

- (void)touchesEnded
{
    NSIndexPath *currentIndexPath = self.selectedItemIndexPath;
    if (currentIndexPath)
    {
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:willEndDraggingItemAtIndexPath:)])
        {
            [self.delegate collectionView:self.collectionView layout:self willEndDraggingItemAtIndexPath:currentIndexPath];
        }
        
        self.selectedItemIndexPath = nil;
        self.currentViewCenter = CGPointZero;
        
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:currentIndexPath];
        
        [UIView
         animateWithDuration:0.3
         delay:0.0
         options:UIViewAnimationOptionBeginFromCurrentState
         animations:^{
             self.currentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
             self.currentView.center = layoutAttributes.center;
         }
         completion:^(BOOL finished)
         {
             [self.currentView removeFromSuperview];
             self.currentView = nil;
             [self invalidateLayout];
             
             if ([self.delegate respondsToSelector:@selector(collectionView:layout:didEndDraggingItemAtIndexPath:)])
             {
                 [self.delegate collectionView:self.collectionView layout:self didEndDraggingItemAtIndexPath:currentIndexPath];
             }
             [self.collectionViewMovingItemPlaceholderView removeFromSuperview];
         }];
        [self removeHiddenCells];
        [self invalidateLayout];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *currentIndexPath = [self.collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:self.collectionView]];
            if (currentIndexPath)
            {
                [self touchesBegan:currentIndexPath];
                self.collectionView.scrollEnabled = NO;
            }
        } break;
        case UIGestureRecognizerStateChanged:
        {
            if ((self.selectedItemIndexPath != nil))
            {
                [super handlePanGesture:gestureRecognizer];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            [self touchesEnded];
            self.collectionView.scrollEnabled = YES;
        }
            break;
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateFailed:
        {
            // Do nothing...
            [super handlePanGesture:gestureRecognizer];
        }
            break;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.isEditing)
    {
        return YES;
    }
    return NO;
}

- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    
    [self showOrHideXOnItems];
    //[self.collectionView reloadData];
    //do not reload data unless you call showOrHideXOnItems or
    //      or your method cellForItemAtIndexPath sets the delegate and calls showDeleteButton method
    // place X on the visible cells
}

- (void)showOrHideXOnItems
{
    NSArray *layoutAttrsInRect = [self.collectionView.collectionViewLayout layoutAttributesForElementsInRect:self.collectionView.bounds];
    NSMutableArray *indexPaths = [[NSMutableArray alloc]initWithCapacity:10];
    for (UICollectionViewLayoutAttributes *layoutAttr in layoutAttrsInRect)
    {
        UICollectionViewCell *collectionViewCell = [self.collectionView cellForItemAtIndexPath:layoutAttr.indexPath];
        if ([collectionViewCell isKindOfClass:[SCUDefaultCollectionViewCell class]])
        {
            BOOL canEdit = NO;
            
            if (self.isEditing && [self.dataSource respondsToSelector:@selector(collectionView:canEditItemAtIndexPath:)])
            {
                canEdit = [self.dataSource collectionView:self.collectionView canEditItemAtIndexPath:layoutAttr.indexPath];
            }
            
            [((SCUDefaultCollectionViewCell *)collectionViewCell) setDelegate:self];
            [((SCUDefaultCollectionViewCell *)collectionViewCell) showDeleteButton:canEdit];
            [indexPaths addObject:layoutAttr.indexPath];
        }
    }
    //[self.collectionView reloadItemsAtIndexPaths:indexPaths];
    //do not reload cells unless you call showOrHideXOnItems or
    //      or your method cellForItemAtIndexPath sets the delegate and calls showDeleteButton method
}

- (void)setCollectionViewMovingItemPlaceholderView:(UIView *)collectionViewMovingItemPlaceholderView
{
    _collectionViewMovingItemPlaceholderView = collectionViewMovingItemPlaceholderView;
    _collectionViewMovingItemPlaceholderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (id<SCUReorderableCollectionViewDataSource>)dataSource
{
    return (id<SCUReorderableCollectionViewDataSource>)self.collectionView.dataSource;
}

- (id<LXReorderableCollectionViewDelegateFlowLayout>)delegate
{
    return (id<LXReorderableCollectionViewDelegateFlowLayout>)self.collectionView.delegate;
}

@end

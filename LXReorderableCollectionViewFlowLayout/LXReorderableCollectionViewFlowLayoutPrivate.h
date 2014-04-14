//
//  LXReorderableCollectionViewFlowLayoutPrivate.h
//  LXRCVFL Example using Storyboard
//
//  Created by Jason Wolkovitz on 4/11/14.
//  Copyright (c) 2014 d--buzz. All rights reserved.
//

#define LX_FRAMES_PER_SECOND 60.0

#ifndef CGGEOMETRY_LXSUPPORT_H_
CG_INLINE CGPoint
LXS_CGPointAdd(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}
#endif

typedef NS_ENUM(NSInteger, LXScrollingDirection) {
    LXScrollingDirectionUnknown = 0,
    LXScrollingDirectionUp,
    LXScrollingDirectionDown,
    LXScrollingDirectionLeft,
    LXScrollingDirectionRight
};

static NSString * const kLXScrollingDirectionKey = @"LXScrollingDirection";
static NSString * const kLXCollectionViewKeyPath = @"collectionView";

@interface CADisplayLink (LX_userInfo)
@property (nonatomic, copy) NSDictionary *LX_userInfo;
@end

@interface UICollectionViewCell (LXReorderableCollectionViewFlowLayout)

- (UIImage *)LX_rasterizedImage;

@end

@interface LXReorderableCollectionViewFlowLayout ()

@property (strong, nonatomic) NSIndexPath *selectedItemIndexPath;
@property (strong, nonatomic) UIView *currentView;
@property (assign, nonatomic) CGPoint currentViewCenter;
@property (assign, nonatomic) CGPoint panTranslationInCollectionView;
@property (strong, nonatomic) CADisplayLink *displayLink;

- (void)setDefaults;
- (void)setupCollectionView;
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes;
- (void)invalidateLayoutIfNecessary;
- (void)invalidatesScrollTimer;
- (void)setupScrollTimerInDirection:(LXScrollingDirection)direction;

#pragma mark - Target/Action methods
// Tight loop, allocate memory sparely, even if they are stack allocation.
- (void)handleScroll:(CADisplayLink *)displayLink;
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer;
- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer;

#pragma mark - Target/Action helper methods
- (NSIndexPath *)indexPathForItemClosestToPoint:(CGPoint)point orginalIndexPath:(NSIndexPath*)orginalIndexPath;

#pragma mark - UICollectionViewLayout overridden methods
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect;
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Notifications
- (void)handleApplicationWillResignActive:(NSNotification *)notification;

@end
//
//  SCUReorderableCollectionViewFlowLayout.h
//
//  Created by Jason Wolkovitz on 4/10/14.
//

#import "LXReorderableCollectionViewFlowLayout.h"
#import "SCUDefaultCollectionViewCell.h"

typedef NS_ENUM(NSInteger, SCUReorderableCollectionViewItemEditingStyle)
{
    SCUCollectionViewItemEditingStyleNone,
    SCUCollectionViewItemEditingStyleDelete,
    SCUCollectionViewItemEditingStyleInsert
};

@protocol SCUReorderableCollectionViewDataSource <LXReorderableCollectionViewDataSource>

@optional
// Individual Items can opt out of having the -editing property set for them. If not implemented, all Items are assumed to be editable.
- (BOOL)collectionView:(UICollectionView *)collectionView canEditItemAtIndexPath:(NSIndexPath *)indexPath;
// After a Item has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
- (void)collectionView:(UICollectionView *)collectionView commitEditingStyle:(SCUReorderableCollectionViewItemEditingStyle)editingStyle forItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface SCUReorderableCollectionViewFlowLayout : LXReorderableCollectionViewFlowLayout <UIGestureRecognizerDelegate, SCUCollectionViewCellDeleteButtonDelegate>
@property (strong, nonatomic) UIView *rightCornerDeleteButtonView;
@property (strong, nonatomic) UIView *collectionViewMovingItemPlaceholderView;
@property (weak, nonatomic) id<LXReorderableCollectionViewDelegateFlowLayout> deleteButtonDelegate;
@property (nonatomic, getter = isEditing) BOOL editing;

@end




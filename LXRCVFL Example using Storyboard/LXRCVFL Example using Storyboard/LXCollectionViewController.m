//
//  LXCollectionViewController.m
//  LXRCVFL Example using Storyboard
//
//  Created by Stan Chang Khin Boon on 3/10/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "LXCollectionViewController.h"
#import "PlayingCard.h"
#import "PlayingCardCell.h"
//#import "SCUReorderableCollectionViewFlowLayout.h"
#import "SCUDefaultCollectionViewCell.h"
// LX_LIMITED_MOVEMENT:
// 0 = Any card can move anywhere
// 1 = Only Spade/Club can move within same rank

#define LX_LIMITED_MOVEMENT 0

@implementation LXCollectionViewController

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"picked");
}

- (void)viewDidLoad {
    self.isInEditMode = NO;

    [super viewDidLoad];
    if([self.collectionViewLayout isKindOfClass:[SCUReorderableCollectionViewFlowLayout class]])
    {
        UIView *blueView = [[ UIView alloc] init ];
        [blueView setBackgroundColor:[UIColor blueColor]];
        [((SCUReorderableCollectionViewFlowLayout *)self.collectionViewLayout) setCollectionViewMovingItemPlaceholderView:blueView];
    }
    self.deck = [self constructsDeck];
    UIButton* editButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [editButton addTarget:self action:@selector(changeEditMode) forControlEvents:UIControlEventTouchUpInside];
    [editButton setCenter: self.collectionView.center];
    [self.collectionView addSubview:editButton];
}

- (void) changeEditMode
{
    self.isInEditMode = !self.isInEditMode;
    [((SCUReorderableCollectionViewFlowLayout *)self.collectionViewLayout) setEditing:self.isInEditMode];
}

- (NSMutableArray *)constructsDeck {
    NSMutableArray *newDeck = [NSMutableArray arrayWithCapacity:52];
    
    for (NSInteger rank = 1; rank <= 13; rank++) {
        // Spade
        {
            PlayingCard *playingCard = [[PlayingCard alloc] init];
            playingCard.suit = PlayingCardSuitSpade;
            playingCard.rank = rank;
            [newDeck addObject:playingCard];
        }
        
        // Heart
        {
            PlayingCard *playingCard = [[PlayingCard alloc] init];
            playingCard.suit = PlayingCardSuitHeart;
            playingCard.rank = rank;
            [newDeck addObject:playingCard];
        }
        
        // Club
        {
            PlayingCard *playingCard = [[PlayingCard alloc] init];
            playingCard.suit = PlayingCardSuitClub;
            playingCard.rank = rank;
            [newDeck addObject:playingCard];
        }
        
        
// Diamond
        {
            PlayingCard *playingCard = [[PlayingCard alloc] init];
            playingCard.suit = PlayingCardSuitDiamond;
            playingCard.rank = rank;
            [newDeck addObject:playingCard];
        }
    }
    
    return newDeck;
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)theCollectionView numberOfItemsInSection:(NSInteger)theSectionIndex {
    return self.deck.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayingCard *playingCard = [self.deck objectAtIndex:indexPath.item];
    PlayingCardCell *playingCardCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCardCell" forIndexPath:indexPath];
    playingCardCell.playingCard = playingCard;
    
    return playingCardCell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   [((SCUReorderableCollectionViewFlowLayout *)self.collectionViewLayout) setEditing:self.isInEditMode];
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return !self.isInEditMode;
}

#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    PlayingCard *playingCard = [self.deck objectAtIndex:fromIndexPath.item];

    [self.deck removeObjectAtIndex:fromIndexPath.item];
    [self.deck insertObject:playingCard atIndex:toIndexPath.item];
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
#if LX_LIMITED_MOVEMENT == 1
    PlayingCard *fromPlayingCard = [deck objectAtIndex:fromIndexPath.item];
    PlayingCard *toPlayingCard = [deck objectAtIndex:toIndexPath.item];
    
    switch (toPlayingCard.suit) {
        case PlayingCardSuitSpade:
        case PlayingCardSuitClub:
            return fromPlayingCard.rank == toPlayingCard.rank;
        default:
            return NO;
    }
#else
    return YES;
#endif
}

-(BOOL)collectionView:(UICollectionView *)collectionView canEditItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView commitEditingStyle:(SCUReorderableCollectionViewItemEditingStyle)editingStyle forItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (editingStyle)
    {
        case SCUCollectionViewItemEditingStyleDelete:
        {
            [self.deck removeObjectAtIndex:indexPath.item];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
            break;
            
        default:
            break;
    }
}

-(void)collectionView:(UICollectionView*) collectionView addItem:(id)item
{
    [self.deck addObject:item];
    [self.collectionView reloadData];
}

#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
   // NSLog(@"will begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"did begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
     //NSLog(@"will end drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"did end drag");
}

@end

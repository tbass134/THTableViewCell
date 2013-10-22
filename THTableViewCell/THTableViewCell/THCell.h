//
//  ActivityCell.h
//  Birdhouse
//
//  Created by Antonio Hung on 6/26/13.
//  Copyright (c) 2013 Andrew Milgrom. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    THCellSwipeDirectionRight = 0,
    THCellSwipeDirectionLeft,
    THCellSwipeDirectionBoth,
    THCellSwipeDirectionNone,
} THCellSwipeDirection;

@protocol THCellDelegate <NSObject>

-(void)cellDidReceiveSwipe:(THCell *)cell;
-(void)toggleCompletion:(THCell *)cell;
-(void)editActivity:(THCell *)cell;
-(void)deleteActivity:(THCell *)cell;

@end

@interface THCell : UITableViewCell {
    
    BOOL expanded;
    UIButton *editBtn;
    UIButton *delBtn;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *activityImage;
@property (weak, nonatomic) IBOutlet UILabel *activityTime;
@property (weak, nonatomic) IBOutlet UILabel *activityText;
@property (weak, nonatomic) IBOutlet UIImageView *noteImage;
@property (weak, nonatomic) IBOutlet UILabel *noteText;

@property (nonatomic, assign) id <THCellDelegate> delegate;
@property (nonatomic, assign) THCellSwipeDirection swipeDirection;
@property (nonatomic, retain) UISwipeGestureRecognizer *lastGestureRecognized;
@property (weak, nonatomic) IBOutlet UIButton *dropdownBtn;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL expanded;
@property (nonatomic, assign) BOOL swiped;
@property (nonatomic, assign) BOOL disableEditSwipe;

/** Slides the content view out to the right to reveal the background view. */
- (void)slideOutContentView;

/** Slides the content view back in to cover the background view. */
- (void)slideInContentView;

-(void)disableCell:(BOOL)disable;

-(void)expand;
-(void)contract;
-(int)getHeight;
-(void)showLine:(BOOL)show;
@end

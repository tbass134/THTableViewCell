//
//  THViewController.h
//  THTableViewCell
//
//  Created by Antonio Hung on 10/1/13.
//  Copyright (c) 2013 Dark Bear Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THCell.h"
@interface THViewController : UITableViewController<THCellDelegate>\

@property (nonatomic, retain) THCell *currentlyActiveSlidingCell;
@property (nonatomic, retain) THCell *selectedCell;
@property (nonatomic, assign) THCell swipeDirection;
@end

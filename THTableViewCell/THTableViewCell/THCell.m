//
//  ActivityCell.m
//  Birdhouse
//
//  Created by Antonio Hung on 6/26/13.
//  Copyright (c) 2013 Andrew Milgrom. All rights reserved.
//

#import "THCell.h"

@interface THCell ()
- (void)addSwipeGestureRecognizer:(UISwipeGestureRecognizerDirection)direction;
@end

@implementation THCell

@synthesize delegate;
@synthesize swipeDirection;
@synthesize lastGestureRecognized;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    }
    return self;
}
-(void)layoutSubviews
{
    self.activityText.numberOfLines = MAXFLOAT;
    UIView *defaultBackgroundView = [[UIView alloc] initWithFrame:self.contentView.frame];
    defaultBackgroundView.backgroundColor = [UIColor darkGrayColor];
   self.backgroundView = defaultBackgroundView;
    
    //add edit and delete buttons
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.backgroundColor = [UIColor darkGrayColor];

    [editBtn addTarget:self
           action:@selector(edit:)
    forControlEvents:UIControlEventTouchDown];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:15];

    [editBtn setTitle:@"Edit" forState:UIControlStateNormal];
    editBtn.frame = CGRectMake(self.frame.size.width-50, 0.0, 50, self.frame.size.height);
    [self.backgroundView addSubview:editBtn];
    
    
    delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.backgroundColor = [UIColor redColor];
    [delBtn addTarget:self
            action:@selector(delete:)
    forControlEvents:UIControlEventTouchDown];
    delBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [delBtn setTitle:@"Delete" forState:UIControlStateNormal];
    delBtn.frame = CGRectMake(self.frame.size.width-100, 0.0, 50, self.frame.size.height);
    [self.backgroundView addSubview:delBtn];
    
    
    editBtn.hidden = delBtn.hidden = YES;

    self.expanded = NO;
}
-(void)setCell
{

    self.noteText.text = @"";
    self.activityText.text = @"";
    self.activityTime.text = @"";
    self.activityImage.image = nil;
    self.disableEditSwipe = NO;
    //get the width of time label and description
    CGSize activityTimeSize = [self.activityTime.text sizeWithFont:self.activityTime.font];
    
    CGSize maximumLabelSize = CGSizeMake(160, FLT_MAX);
    CGSize activityTextSize = [self.activityText.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];

    
    CGRect activityTimeLabelRect = self.activityTime.frame;
    activityTimeLabelRect.size.width = activityTimeSize.width;
    CGRect activityTextLabelRect = self.activityText.frame;
    activityTextLabelRect.size.width = 160;
    
    if(activityTextSize.height>44)
    {
        activityTextLabelRect.size.height = activityTextSize.height+15;
        
        activityTimeLabelRect.origin.y = self.activityText.frame.size.height/2;
        
        CGRect activityImageFrame = self.activityImage.frame;
        activityImageFrame.origin.y = self.activityText.frame.size.height/2;
        //self.activityImage.frame = activityImageFrame;
    }
    else
    {
        activityTextLabelRect.origin.y = 0;
        activityTextLabelRect.size.height = 44;
    }

    
    self.activityText.frame = activityTextLabelRect;
    

    UIView *lineView = (UIView *)[self viewWithTag:200];
    CGRect lineViewFrame = lineView.frame;
    if(activityTextSize.height>43)
        lineViewFrame.origin.y = activityTextSize.height+15;
    else
        lineViewFrame.origin.y = 43;
    lineView.frame = lineViewFrame;
    
    self.noteImage.hidden = YES;
    lineView.hidden = NO;
    
    NSString *note = @"Some Note Text";
    if(note)
    {
        self.noteText.text = note;
        self.noteImage.hidden = NO;

        CGRect noteImageFrame = self.noteImage.frame;
        noteImageFrame.origin.x = self.activityText.frame.origin.x + activityTextSize.width +10;
        if( noteImageFrame.origin.x >self.frame.size.width)
            noteImageFrame.origin.x = self.frame.size.width - self.noteImage.frame.size.width-10;
        
         //if( self.activityText.frame.size.height>44)
         //{
             //reposition the image in the center of the cell
             noteImageFrame.origin.y = (self.activityText.frame.size.height/2)-10   ;
         //}
        
        self.noteImage.frame = noteImageFrame;
        
        
        CGSize noteTextSize = [self.noteText.text sizeWithFont:self.noteText.font constrainedToSize:CGSizeMake(self.noteText.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByClipping];
        
        CGRect noteTextRect = self.noteText.frame;
        // if(noteSize.height >40)
        noteTextRect.size.height = noteTextSize.height;
        
        
        
        if( self.activityText.frame.size.height>44)
            noteTextRect.origin.y = self.activityText.frame.size.height;
        else
            noteTextRect.origin.y = 44;
        self.noteText.frame = noteTextRect;
        self.noteText.hidden = NO;
        
        UIView *noteLineView = (UIView *)[self viewWithTag:201];
        CGRect noteLineViewFrame = noteLineView.frame;
        noteLineViewFrame.origin.y = self.noteText.frame.origin.y + self.noteText.frame.size.height-1;
        noteLineView.frame = noteLineViewFrame;

        

        //update the height of the background iage
        //UIImageView *noteBG = (UIImageView *)[self viewWithTag:200];
        //noteBG.frame = CGRectMake(0, noteBG.frame.origin.y, noteBG.frame.size.width, noteTextSize.height+5);
        
        
        UIView *lineView = (UIView *)[self viewWithTag:200];

        lineView.hidden = YES;
        //NSLog(@"self.frame.size.height %f",self.frame.size.height);
        
        if(self.frame.size.height >44)
        {
            if(self.frame.size.height >self.noteText.frame.size.height + (self.activityText.frame.size.height/2))
                lineView.hidden = YES;
            else
                lineView.hidden = NO;
        }
        else
            lineView.hidden = NO;
         
        
       
 
         
    }
    
    self.contentView.backgroundColor = [UIColor whiteColor];
}

-(void)adjustContentHeight
{
    
}
-(int)getHeight
{    
    //CGSize activityTextSize = [self.activityText.text sizeWithFont:self.activityText.font];
    CGSize maximumLabelSize = CGSizeMake(self.activityText.frame.size.width, MAXFLOAT);

    CGSize activityTextSize = [self.activityText.text sizeWithFont:self.activityText.font constrainedToSize:maximumLabelSize lineBreakMode:self.activityText.lineBreakMode];
    
    int height = 0;
    if(![self.noteText.text isEqualToString:@""])
    {
        UIView *lineView = (UIView *)[self viewWithTag:201];
        height = lineView.frame.origin.y+1;
        /*
        height =  activityTextSize.height + 15 + self.noteText.frame.size.height+10;
        
        if(activityTextSize.height >19)
           height -=15;
         */
    }
    else
        height = 44;
    
    return height;
}
-(void)expand
{
    if(self.noteText.text.length ==0)return;
    if(!self.expanded)
    {
        CGRect	oldFrame = [self frame];
        /*
        [self setFrame:CGRectMake(	oldFrame.origin.x,
                                  oldFrame.origin.y,
                                  oldFrame.size.width,
                                  oldFrame.size.height * 2)];
         */
        
    }
    
    self.expanded = YES;
}

-(void)contract
{
    //UIView *lineView = (UIView *)[self viewWithTag:200];
    //lineView.hidden = NO;
    
	CGRect	oldFrame = [self frame];
    if(self.expanded)
    {
        /*
        [self setFrame:CGRectMake(	oldFrame.origin.x,
                              oldFrame.origin.y,
                              oldFrame.size.width,
                              oldFrame.size.height / 2)];
         */


    }
    
    self.expanded = NO;
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture
{
    if(gesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if(!self.disableEditSwipe)
        {
            [self setLastGestureRecognized:gesture];
            [self slideOutContentView];
            [self.delegate cellDidReceiveSwipe:self];
        }
    }
    else if(gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        
        if(!editBtn.hidden)
        {
            
            printf("slide in");
            
            
            //[self slideInContentView];
            //[self.delegate cellDidReceiveSwipe:self];

        }
        else
        {
            [self.delegate toggleCompletion:self];
        }
        //self.contentView.backgroundColor = [UIColor whiteColor];

    }
}

- (void)setSwipeDirection:(THCellSwipeDirection)direction
{
    swipeDirection = direction;
    
    NSArray *existingGestures = [self gestureRecognizers];
    for (UIGestureRecognizer *gesture in existingGestures) {
        [self removeGestureRecognizer:gesture];
    }
    
    [self addSwipeGestureRecognizer:UISwipeGestureRecognizerDirectionLeft];
    [self addSwipeGestureRecognizer:UISwipeGestureRecognizerDirectionRight];
}

- (void)addSwipeGestureRecognizer:(UISwipeGestureRecognizerDirection)direction;
{
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeGesture.direction = direction;
    [self addGestureRecognizer:swipeGesture];
}

#pragma mark Edit / Delete
-(void)edit:(id)sender
{
    [self.delegate editActivity:self];
}
-(void)delete:(id)sender
{
    [self.delegate deleteActivity:self];
}

-(void)disableCell:(BOOL)disable
{
    float alpha = 1;
    if(disable)
        alpha = 0.2;
        
    self.activityImage.alpha  =alpha;
    self.activityText.alpha = alpha;
    self.activityTime.alpha = alpha;
        
}

#pragma mark Sliding content view
#define kBOUNCE_DISTANCE 20.0
#define kWidth 100.0

void LR_offsetView(UIView *view, CGFloat offsetX, CGFloat offsetY)
{
    view.frame = CGRectOffset(view.frame, offsetX, offsetY);
}

- (void)slideOutContentView;
{
    //update the height of the edit and delete buttons to the frame height
    CGRect editButFrame = editBtn.frame;
    CGRect delBtnFrame = delBtn.frame;
    
    editButFrame.size.height = delBtnFrame.size.height = self.frame.size.height;
    editBtn.frame = editButFrame;
    delBtn.frame = delBtnFrame;
    
   
    CGFloat offsetX;
    
    switch (self.lastGestureRecognized.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            offsetX = -kWidth;
            editBtn.hidden = delBtn.hidden = NO;

            break;
        case UISwipeGestureRecognizerDirectionRight:
            offsetX = kWidth;
            editBtn.hidden = delBtn.hidden = NO;

            break;
        default:
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unhandled gesture direction" userInfo:[NSDictionary dictionaryWithObject:self.lastGestureRecognized forKey:@"lastGestureRecognized"]];
            break;
    }
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{ LR_offsetView(self.contentView, offsetX, 0); }
                     completion:NULL];
}

- (void)slideInContentView;
{
    
    //update the height of the edit and delete buttons to the frame height
    CGRect editButFrame = editBtn.frame;
    CGRect delBtnFrame = delBtn.frame;
    
    editButFrame.size.height = delBtnFrame.size.height = self.frame.size.height;
    editBtn.frame = editButFrame;
    delBtn.frame = delBtnFrame;
    
    
    UIView *defaultBackgroundView = (UIView *)[self.contentView viewWithTag:303];
    [self.contentView bringSubviewToFront:defaultBackgroundView];

    CGFloat offsetX, bounceDistance;
    
    switch (self.lastGestureRecognized.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            offsetX = kWidth;;
            bounceDistance = -kBOUNCE_DISTANCE;
            break;
        case UISwipeGestureRecognizerDirectionRight:
            offsetX = -kWidth;
            bounceDistance = kBOUNCE_DISTANCE;
            break;
        default:
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unhandled gesture direction" userInfo:[NSDictionary dictionaryWithObject:self.lastGestureRecognized forKey:@"lastGestureRecognized"]];
            break;
    }
    
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction
                     animations:^{ LR_offsetView(self.contentView, offsetX, 0); }
                     completion:^(BOOL f) {
                         
                         [UIView animateWithDuration:0.1 delay:0
                                             options:UIViewAnimationCurveLinear
                                          animations:^{ LR_offsetView(self.contentView, bounceDistance, 0); }
                                          completion:^(BOOL f) {                     
                                              
                                              [UIView animateWithDuration:0.1 delay:0 
                                                                  options:UIViewAnimationCurveLinear
                                                               animations:^{ LR_offsetView(self.contentView, -bounceDistance, 0); } 
                                                               completion:NULL];
                                          }
                          ];   
                     }];
}
@end

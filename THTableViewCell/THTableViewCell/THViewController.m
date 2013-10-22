//
//  THViewController.m
//  THTableViewCell
//
//  Created by Antonio Hung on 10/1/13.
//  Copyright (c) 2013 Dark Bear Interactive. All rights reserved.
//

#import "THViewController.h"

@interface THViewController ()

@end

@implementation THViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return a cell with the activity type and picture
    static NSString *CellIdentifier = @"Cell";
    
    THCell *cell = (THCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[THCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.swipeDirection = self.swipeDirection;
    cell.delegate = self;
    return cell;
}

#pragma mark BHActivityCellDelegate
- (void)cellDidReceiveSwipe:(THCell *)cell
{
    self.currentlyActiveSlidingCell = cell;
}
- (void)setCurrentlyActiveSlidingCell:(THCell *)cell
{
    [_currentlyActiveSlidingCell slideInContentView];
    _currentlyActiveSlidingCell = cell;
}
-(void)toggleCompletion:(THCell *)cell
{
    NSIndexPath *currentIndexPath = [self.tableView indexPathForCell:cell];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:NO];
    [self.tableView endUpdates];
    

    
    
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:currentIndexPath.section];
    NSArray *eventsOnThisDay  = [self sortedItems:dateRepresentingThisDay];
    
    
    
    if([[eventsOnThisDay objectAtIndex:currentIndexPath.row] isKindOfClass:[BHActivity class]])
    {
        // activtyCell.activity =  [eventsOnThisDay objectAtIndex:indexPath.row];
        BHActivity *activity = [eventsOnThisDay objectAtIndex:currentIndexPath.row];
        currentSelection = TOGGLE_COMPLETE;
        
        if(activity.activityType == ActivityTypeNutrition)
        {
            recentlyCompletedActivityFromNutrition = activity;
            
            [self deleteActivityWithID:[activity.activityId intValue]];
            
        }
        else if(activity.activityType == ActivityTypeTherapy)
        {
            recentlyCompletedActivityFromTherapist = activity;
            
            //need to chaneg the activity back to nutrition.
            [self deleteActivityWithID:[activity.activityId intValue]];
        }
        else
        {
            printf("do nothing");
            //disabledIndexPath = nil;
            
            if([disabledCells containsObject:currentIndexPath])
                [disabledCells removeObject:currentIndexPath];
            
            [self.table_view beginUpdates];
            [self.table_view reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:NO];
            [self.table_view endUpdates];
        }
        
    }
    else if([[eventsOnThisDay objectAtIndex:currentIndexPath.row] isKindOfClass:[BHNutrition class]])
    {
        BHNutrition *nutrition = [eventsOnThisDay objectAtIndex:currentIndexPath.row];
        
        
        //GET THE TIME FROM THE DATE
        NSDateComponents *timeComponentFromDate = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit
                                                                                  fromDate:nutrition.activityDate];
        
        NSTimeInterval ts = (timeComponentFromDate.hour * 60 * 60) + timeComponentFromDate.minute*60;
        nutrition.activityDate = [dateRepresentingThisDay dateByAddingTimeInterval:ts];
        
        /*
         NSString *json_str = @"{\"activity_attributes\":{\"nutrition_id\":\"517\",\"nutrition_type\":\"Supplement\",\"nutrition_name\":\"bacon\",\"dosage_amount\":\"100\",\"dosage_unit\":\"strips\"},\"activity_date\":\"2013-07-21T10:45:00-04:00\",\"activity_type\":\"Nutrition\",\"child_id\":395,\"created_at\":\"2013-07-22T16:32:18-04:00\",\"description\":null,\"id\":10419,\"note\":null,\"recurring\":true,\"recurring_status\":true,\"session_id\":7172,\"status\":null,\"type_id\":null,\"updated_at\":\"2013-07-22T16:32:18-04:00\"}";
         
         NSData* data = [json_str dataUsingEncoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *activityDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
         
         NSLog(@"activityDictionary %@",activityDictionary);
         
         BHActivity *newActivty = [[BHActivity alloc]initWithDictionary:activityDictionary];
         
         NSLog(@"newActivty.activityDate %@",newActivty.activityDate);
         
         
         
         NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:currentIndexPath.section];
         NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"activityDate" ascending:NO selector:@selector(compare:)];
         
         NSMutableArray *eventsOnThisDay  = [[NSMutableArray alloc]initWithArray:[[self.sections objectForKey:dateRepresentingThisDay] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]];
         
         //[self.table_view beginUpdates];
         [eventsOnThisDay replaceObjectAtIndex:currentIndexPath.row withObject:newActivty];
         
         [self.sections setObject:eventsOnThisDay forKey:dateRepresentingThisDay];
         //[self.table_view reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:NO];
         //[self.table_view endUpdates];
         [self.table_view reloadData];
         
         return;
         */
        
        
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit )
                                                    fromDate:nutrition.activityDate];
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        
        //date
        [df setDateFormat:@"MM/dd/yyyy"];
        NSString *date_str  = [df stringFromDate:nutrition.activityDate];
        
        
        //am pm
        [df setDateFormat:@"a"];
        NSString *ampm = [df stringFromDate:nutrition.activityDate];
        
        
        //time
        [df setDateFormat:@"hh:mm a"];
        NSString *time = [df stringFromDate:nutrition.activityDate];
        
        //time(hr)
        [df setDateFormat:@"hh"];
        NSString *hour = [df stringFromDate:nutrition.activityDate];
        
        
        //month name abbreviated
        [df setDateFormat:@"MMM"];
        NSString *month_name_abbrivated = [df stringFromDate:nutrition.activityDate];
        
        //month name ful
        [df setDateFormat:@"MMMM"];
        NSString *month_name_full = [df stringFromDate:nutrition.activityDate];
        
        
        NSDictionary *activity_attributes = @{@"dosage_amount":nutrition.dosageAmount,
                                              @"dosage_unit":nutrition.dosageUnit,
                                              @"nutrition_id":nutrition.nutritionId,
                                              @"nutrition_name":nutrition.name,
                                              @"nutrition_type":nutrition.nutrition_type};
        
        NSDictionary *activityDict = @{@"activity_ampm":[ampm lowercaseString],
                                       @"activity_attributes":activity_attributes,
                                       @"activity_date":date_str,
                                       @"activity_day":[NSNumber numberWithInt:[components day]],
                                       @"activity_hour":hour,
                                       @"activity_minute":[NSNumber numberWithInt:[components minute]],
                                       @"activity_month":month_name_abbrivated,
                                       @"activity_month_pretty":month_name_full,
                                       @"activity_time_pretty":time,
                                       @"activity_type":@"Nutrition",
                                       @"activity_year":[NSNumber numberWithInt:[components year]],
                                       @"child_id":nutrition.childId,
                                       @"js_activity_date":[NSNumber numberWithInt:[nutrition.activityDate timeIntervalSince1970]],
                                       @"recurring":[nutrition.periodAttributes objectForKey:@"recurring"],
                                       @"recurringModelId":nutrition.nutritionId,
                                       @"recurring_status":[nutrition.periodAttributes objectForKey:@"recurring"],
                                       
                                       };
        
        //NSLog(@"activityDict %@",activityDict);
        [self postActivityWithDictionary:activityDict];
        
        
    }
    else if([[eventsOnThisDay objectAtIndex:currentIndexPath.row] isKindOfClass:[BHTherapists class]])
    {
        BHTherapists *therapist =  [eventsOnThisDay objectAtIndex:currentIndexPath.row];
        
        
        //GET THE TIME FROM THE DATE
        NSDateComponents *timeComponentFromDate = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit
                                                                                  fromDate:therapist.activityDate];
        
        NSTimeInterval ts = (timeComponentFromDate.hour * 60 * 60) + timeComponentFromDate.minute*60;
        therapist.activityDate = [dateRepresentingThisDay dateByAddingTimeInterval:ts];
        
        
        
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit )
                                                    fromDate:therapist.activityDate];
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        
        //date
        [df setDateFormat:@"MM/dd/yyyy"];
        NSString *date_str  = [df stringFromDate:therapist.activityDate];
        
        
        //am pm
        [df setDateFormat:@"a"];
        NSString *ampm = [df stringFromDate:therapist.activityDate];
        
        
        //time
        [df setDateFormat:@"hh:mm a"];
        NSString *time = [df stringFromDate:therapist.activityDate];
        
        //time(hr)
        [df setDateFormat:@"hh"];
        NSString *hour = [df stringFromDate:therapist.activityDate];
        
        
        //month name abbreviated
        [df setDateFormat:@"MMM"];
        NSString *month_name_abbrivated = [df stringFromDate:therapist.activityDate];
        
        //month name ful
        [df setDateFormat:@"MMMM"];
        NSString *month_name_full = [df stringFromDate:therapist.activityDate];
        
        NSDictionary *activity_attributes = @{@"therapist_id":therapist.therapistId};
        
        NSDictionary *therapistDict = @{@"activity_ampm":[ampm lowercaseString],
                                        @"activity_attributes":activity_attributes,
                                        @"activity_date":date_str,
                                        @"activity_day":[NSNumber numberWithInt:[components day]],
                                        @"activity_hour":hour,
                                        @"activity_minute":[NSNumber numberWithInt:[components minute]],
                                        @"activity_month":month_name_full,
                                        @"activity_month_pretty":month_name_abbrivated,
                                        @"activity_time_pretty":time,
                                        @"activity_type":@"Therapy",
                                        @"activity_year":[NSNumber numberWithInt:[components year]],
                                        @"child_id":therapist.childId,
                                        @"js_activity_date":[NSNumber numberWithInt:[therapist.activityDate timeIntervalSince1970]],
                                        @"recurring":[therapist.periodAttributes objectForKey:@"recurring"],
                                        @"recurringModelId":therapist.therapistId,
                                        @"recurring_status":[therapist.periodAttributes objectForKey:@"recurring"],
                                        
                                        };
        
        
        //NSLog(@"therapistsDict %@",therapistDict);
        [self postActivityWithDictionary:therapistDict];
        
        
        
    }
    
    printf("toggle completion");
}
-(void)editActivity:(THCell *)cell
{
    currentIndexPath = [self.table_view indexPathForCell:cell];
    
    if([disabledCells containsObject:currentIndexPath])
    {
        printf("cell disabled");return;
    }
    
    //disabledIndexPath = currentIndexPath;
    
    [disabledCells addObject:currentIndexPath];
    
    
    
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:currentIndexPath.section];
    NSArray *eventsOnThisDay  = [self sortedItems:dateRepresentingThisDay];
    
    selectedActivity = [eventsOnThisDay objectAtIndex:currentIndexPath.row];
    [self performSegueWithIdentifier:@"activityTableViewControllerToEditActivityViewControllerSegue" sender:nil];
}
-(void)deleteActivity:(THCell *)cell
{
    currentIndexPath = [self.table_view indexPathForCell:cell];
    
    if([disabledCells containsObject:currentIndexPath])
    {
        printf("cell disabled");return;
    }
    
    //disabledIndexPath = currentIndexPath;
    
    [disabledCells addObject:currentIndexPath];
    
    
    
    
    currentSelection = DELETE;
    
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:currentIndexPath.section];
    NSMutableArray *eventsOnThisDay  = [[NSMutableArray alloc]initWithArray:[self sortedItems:dateRepresentingThisDay]];
    
    BHActivity *activity = [eventsOnThisDay objectAtIndex:currentIndexPath.row];
    
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"Are you sure you would like to delete this activity item?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    [as showInView:self.view];
    as.tag = [activity.activityId intValue];
}

@end

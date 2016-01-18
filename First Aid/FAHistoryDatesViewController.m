//
//  FAHistoryDatesViewController.m
//  First Aid
//
//  Created by Wilson on 1/12/16.
//  Copyright © 2016 Willy Co. All rights reserved.
//

#import "FAHistoryDatesViewController.h"
#import "FAStatsViewController.h"

@interface FAHistoryDatesViewController ()
@property (strong, nonatomic) IBOutlet UITableView *dateTableView;
@property (nonatomic) NSDate *historyDate;
@end

@implementation FAHistoryDatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSArray*)datesFromToday {
    NSDate *today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSMutableArray *datesThisMonth = [NSMutableArray array];
    NSRange rangeOfDaysThisMonth = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:today];
    
    NSDateComponents *components = [cal components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra) fromDate:today];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    for (NSInteger i = rangeOfDaysThisMonth.location; i < NSMaxRange(rangeOfDaysThisMonth); ++i) {
        [components setDay:i];
        if ([components day] <= [self dayForToday]) {
            NSDate *dayInMonth = [cal dateFromComponents:components];
            [datesThisMonth addObject:dayInMonth];
        }
        else {
            break;
        }
    }
    
    return datesThisMonth;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self datesFromToday].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dates = [self datesFromToday];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    NSString *dateString = [dateFormatter stringFromDate:[dates objectAtIndex:[dates count] - indexPath.row - 1]];
    
    cell.textLabel.text = dateString;
    
    return cell;
}

-(NSInteger)dayForToday {
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currentDate];
    
    return [components day];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    
    NSDate *date = [dateFormatter dateFromString:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FAStatsViewController *statsController = (FAStatsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"statsController"];
    statsController.dateToLoad = date;
    [[self navigationController] pushViewController:statsController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

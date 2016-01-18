//
//  FAStatsViewController.m
//  First Aid
//
//  Created by Wilson on 1/12/16.
//  Copyright © 2016 Willy Co. All rights reserved.
//

#import "FAStatsViewController.h"
#import <HealthKit/HealthKit.h>
#import "FAHealthManager.h"

@interface FAStatsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *activeCaloriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *exerciseMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursStoodLabel;

@property (weak, nonatomic) IBOutlet UILabel *restingCaloriesLabel;

@property (weak, nonatomic) IBOutlet UILabel *stepsTakenLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceWalkedLabel;
@end

@implementation FAStatsViewController

- (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date = _dateToLoad;
    
    NSDate *startDate = [calendar startOfDayForDate:date];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    return [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
}

- (IBAction)refresh:(id)sender {
    [self refreshData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_dateToLoad == nil) {
        _dateToLoad = [NSDate date];
    }
    [self refreshData];
}

-(void)refreshData {
    HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    [self getQuantativeDataFromTodayForType:activeEnergyBurnType unit:[HKUnit kilocalorieUnit] completion:^(double value, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.activeCaloriesLabel.text = [NSString stringWithFormat:@"%1.0f kcal", value];
        });
    }];
    
    HKQuantityType *exerciseMinutesType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierAppleExerciseTime];
    [self getQuantativeDataFromTodayForType:exerciseMinutesType unit:[HKUnit minuteUnit] completion:^(double value, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.exerciseMinutesLabel.text = [NSString stringWithFormat:@"%1.0f mins", value];
        });
    }];
    
    [self getStandHoursFromTodayWithCompletion:^(int value, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.hoursStoodLabel.text = [NSString stringWithFormat:@"%d hours", value];
        });
    }];
    
    HKQuantityType *restingEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned];
    [self getQuantativeDataFromTodayForType:restingEnergyBurnType unit:[HKUnit kilocalorieUnit] completion:^(double value, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.restingCaloriesLabel.text = [NSString stringWithFormat:@"%1.0f kcal", value];
        });
    }];
    
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    [self getQuantativeDataFromTodayForType:stepType unit:[HKUnit countUnit] completion:^(double value, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.stepsTakenLabel.text = [NSString stringWithFormat:@"%1.0f steps", value];
        });
    }];
    
    HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    [self getQuantativeDataFromTodayForType:distanceType unit:[HKUnit mileUnit] completion:^(double value, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.distanceWalkedLabel.text = [NSString stringWithFormat:@"%1.2f miles", value];
        });
    }];
}

- (void)getQuantativeDataFromTodayForType:(HKQuantityType *)quantityType unit:(HKUnit *)unit completion:(void (^)(double value, NSError *error))completionHandler {
    FAHealthManager *healthManager = [[FAHealthManager alloc] init];
    NSPredicate *predicate = [self predicateForSamplesToday];
    
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        HKQuantity *sum = [result sumQuantity];
        
        if (completionHandler) {
            double value = [sum doubleValueForUnit:unit];
            
            completionHandler(value, error);
        }
    }];
    
    [[healthManager healthStore] executeQuery:query];
}

- (void)getStandHoursFromTodayWithCompletion:(void (^)(int value, NSError *error))completionHandler {
    FAHealthManager *healthManager = [[FAHealthManager alloc] init];
    NSPredicate *predicate = [self predicateForSamplesToday];
    HKSampleType *standType = [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierAppleStandHour];
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:standType predicate:predicate limit:24 sortDescriptors:nil resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        int hours = 0;
        for (HKCategorySample *sample in results) {
            if (sample.value != HKCategoryValueAppleStandHourIdle) {
                hours++;
            }
        }
        
        if (completionHandler) {
            int value = hours;
            
            completionHandler(value, error);
        }
    }];
    
    [[healthManager healthStore] executeQuery:query];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

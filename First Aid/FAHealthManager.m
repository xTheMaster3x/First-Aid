//
//  FAHealthManager.m
//  First Aid
//
//  Created by Wilson on 1/12/16.
//  Copyright © 2016 Willy Co. All rights reserved.
//

#import "FAHealthManager.h"

@implementation FAHealthManager
-(HKHealthStore*)healthStore {
    return [[HKHealthStore alloc] init];
}
-(void)authorizeHealthKit {
    HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *exerciseMinutesType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierAppleExerciseTime];
    HKSampleType *standType = [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierAppleStandHour];
    
    HKQuantityType *restingEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned];
    
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    NSSet *readTypes = [[NSSet alloc] initWithObjects: activeEnergyBurnType, exerciseMinutesType, standType, restingEnergyBurnType, stepType, distanceType, nil];
    
    [[self healthStore] requestAuthorizationToShareTypes:nil readTypes:readTypes completion:^(BOOL success, NSError * _Nullable error) {
        if (error == nil && success) {
            NSLog(@"Success!");
            
        }
        else {
            NSLog(@"Error: %@", error);
        }
    }];
}
@end

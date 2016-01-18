//
//  FAHealthManager.h
//  First Aid
//
//  Created by Wilson on 1/12/16.
//  Copyright © 2016 Willy Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface FAHealthManager : NSObject
-(HKHealthStore*)healthStore;
-(void)authorizeHealthKit;
@end

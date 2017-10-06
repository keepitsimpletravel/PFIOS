//
//  DataSource.h
//
//  Created by Ashley Templeman on 12/06/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Food.h"
#import "Drink.h"
#import "Activity.h"
#import "Room.h"
#import "Detail.h"
#import "Directions.h"
#import "Staff.h"
#import "Step.h"
#import "Network.h"
#import "Transport.h"

@protocol DataSource <NSObject>

// Get all functions
- (NSArray *)getAllFoods;
- (NSArray *)getAllDrinks;
- (NSArray *)getAllRooms;
- (NSArray *)getAllActivities;
- (NSArray *)getAllDirections;
- (NSArray *)getFacilities;
- (NSArray *)getStaff;
- (NSArray *)getNetworks;
- (Detail *)getHostelDetails;
- (NSArray *)getAllTransport;
- (NSArray *)getTravelTips;
- (NSArray *)getWhereNext;
- (NSArray *)getStepsForObject:(NSString *)name;

- (NSArray *)getFoodTypes;
- (NSArray *)getAllFoodsForType:(NSString *)type;
- (NSArray *)getDrinkTypes;
- (NSArray *)getAllDrinksForType:(NSString *)type;
- (NSArray *)getActivityTypes;
- (NSArray *)getAllActivityForType:(NSString *)type;

// need to add the individual get item methods
- (Food *)getFoodByName:(NSString *)name;
- (Drink *)getDrinkByName:(NSString *)name;
- (Room *)getRoomByName:(NSString *)name;
- (Activity *)getActivityByName:(NSString *)name;

- (NSArray *)getPhotoNames:(NSString *)area identifier:(NSString *)idt;
- (NSArray *)getThumbnailNames:(NSString *)area;

@end

@interface DataSource : NSObject {
    
}

+ (id<DataSource>)dataSource;

@end


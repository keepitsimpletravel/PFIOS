//
//  SQLiteDatabase.h
//
//  Created by Ashley Templeman on 12/06/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSource.h"
#import <sqlite3.h>
#import "Food.h"
#import "Drink.h"
#import "Activity.h"
#import "Room.h"
#import "Detail.h"

@interface SQLiteDatabase : NSObject<DataSource> {
    NSString *endpoint;
    NSString *databaseName;
    NSString *databasePath;
}

- (id)initWithDatabase;
- (void)checkAndCreateDatabase;

@end

@interface NSObject (SQLiteDatabase)

@end

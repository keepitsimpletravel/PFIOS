//
//  DataSource.m
//
//  Created by Ashley Templeman on 12/06/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//
// This class is used to set up the intance for the database
//

#import "DataSource.h"
#import "SQLiteDatabase.h"

static id<DataSource> dataSourceSingleton;

@implementation DataSource

+ (void)initialize
{
    static BOOL init = NO;
    if (!init)
    {
        dataSourceSingleton = [[SQLiteDatabase alloc] initWithDatabase];
        init = YES;
    }
}

+ (id<DataSource>)dataSource
{
    return dataSourceSingleton;
}

@end


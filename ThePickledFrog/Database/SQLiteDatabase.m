//
//  SQLiteDatabase.m
//
//  Created by Ashley Templeman on 12/06/2015.
//  Copyright (c) 2015 Keep It Simple Travel. All rights reserved.
//

#import "SQLiteDatabase.h"
#import "PhotoLookup.h"
#import "WhereNext.h"
#import "TravelTip.h"

@implementation SQLiteDatabase

#pragma Database Setup

// Method to setup the database
- (id)initWithDatabase
{
    if ((self = [super init]))
    {
        // Get Config Values
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
        NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        NSString *dbName = [configurationValues objectForKey:@"DatabaseName"];
        
        // in here is where the first part needs to go for the SQLite database
        databaseName = dbName;
        
        // Get the path to the documents directory and append the databaseName
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
        
        // Execute the "checkAndCreateDatabase" function
        [self checkAndCreateDatabase];
        
    }
    return self;
}

// Method to create the database on the device and set it all up
-(void) checkAndCreateDatabase{
    // Check if the SQL database has already been saved to the users phone, if not then copy it over
    BOOL success;
    
    // Create a FileManager object, we will use this to check the status
    // of the database and to copy it over if required
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the database has already been created in the users filesystem
    success = [fileManager fileExistsAtPath:databasePath];
    
    // If the database already exists then return without doing anything
    if(success) return;
    
    // If not then proceed to copy the database from the application to the users filesystem
    
    // Get the path to the database in the application package
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
    // Copy the database from the package to the users filesystem
    [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
}

# pragma All Data
// Get All Directions details
- (NSArray *)getAllDirections
{
    sqlite3 *database;
    NSMutableArray *directions = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStatement;
        NSString *sqlQuery = @"select * from Directions";
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *stationName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *mode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                
                const unsigned char *desc = sqlite3_column_text(compiledStatement, 2);
                NSString *description = @"";
                if (desc){
                    description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                }
                
                Directions *direction = [[Directions alloc] initWithData:stationName mode:mode description:description];
                
                [directions addObject:direction];
            }
        }
    }
    return directions;
}

// Get All Where Next details
- (NSArray *)getWhereNext
{
    sqlite3 *database;
    NSMutableArray *whereNexts = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStatement;
        NSString *sqlQuery = @"select * from Next";
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *blurb = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                
                const unsigned char *desc = sqlite3_column_text(compiledStatement, 2);
                NSString *description = @"";
                if (desc){
                    description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                }
                
                const unsigned char *gt = sqlite3_column_text(compiledStatement, 3);
                NSString *gettingThere = @"";
                if (gt){
                    gettingThere = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                }
                
                const unsigned char *gt2 = sqlite3_column_text(compiledStatement, 4);
                NSString *gettingThere2 = @"";
                if (gt2){
                    gettingThere2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                }
                
                const unsigned char *gt3 = sqlite3_column_text(compiledStatement, 5);
                NSString *gettingThere3 = @"";
                if (gt3){
                    gettingThere3 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                }
                
                WhereNext *next = [[WhereNext alloc] initWithData:name blurb:blurb description:description getting:gettingThere getting2:gettingThere2 getting3:gettingThere3];
                
                [whereNexts addObject:next];
            }
        }
    }
    return whereNexts;
}

// Get All Staff details
- (NSArray *)getStaff
{
    sqlite3 *database;
    NSMutableArray *staffMembers = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStatement;
        NSString *sqlQuery = @"select * from Staff";
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSNumber *ageValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 1)];
                NSInteger age = [ageValue integerValue];
                NSString *hometown = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *books = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *music = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *movies = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                NSString *eat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                NSString *drink = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                NSString *details = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                
                Staff *staff = [[Staff alloc] initWithData:name age:age hometown:hometown books:books music:music movies:movies eat:eat drink:drink details:details];
                
                [staffMembers addObject:staff];
            }
        }
    }
    return staffMembers;

}

// Get All Foods details
- (NSArray *)getAllFoods
{
    sqlite3 *database;
    NSMutableArray *foods = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStatement;
        NSString *sqlQuery = @"select * from Food";
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
                NSNumber *longitudeValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 3)];
                NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithDecimal:[longitudeValue decimalValue]];
                NSNumber *latitudeValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 4)];
                NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithDecimal:[latitudeValue decimalValue]];
                
                const unsigned char *add = sqlite3_column_text(compiledStatement, 5);
                NSString *address = @"";
                if (add){
                    address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                }
                
                const unsigned char *ph = sqlite3_column_text(compiledStatement, 6);
                NSString *phone = @"";
                if (ph){
                    phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                }
                
                const unsigned char *ws = sqlite3_column_text(compiledStatement, 7);
                NSString *website = @"";
                if (ws){
                    website = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                }
                
                NSString *brief = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                
                const unsigned char *oh = sqlite3_column_text(compiledStatement, 9);
                NSString *openingHours = @"";
                if (oh){
                    openingHours = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                }
                
                const unsigned char *talink = sqlite3_column_text(compiledStatement, 10);
                NSString *link = @"";
                if (talink ){
                    link = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                }
                
                const unsigned char *ig = sqlite3_column_text(compiledStatement, 11);
                NSString *iURL = @"";
                if (ig){
                    iURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                }
                
                const unsigned char *fb = sqlite3_column_text(compiledStatement, 12);
                NSString *fURL = @"";
                if (fb){
                    fURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                }
                
                Food *food = [[Food alloc] initWithData:type nm:name ddesc:desc dadd:address web:website lon:longitude lat:latitude phoneNumber:phone br:brief open:openingHours tal:link insta:iURL face:fURL];
                [foods addObject:food];
            }
        }
    }
    return foods;
}

// Get All Drinks details
- (NSArray *)getAllDrinks
{
    sqlite3 *database;
    NSMutableArray *drinks = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStatement;
        NSString *sqlQuery = @"select * from Drink";
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                
                const unsigned char *desc2 = sqlite3_column_text(compiledStatement, 2);
                NSString *description2 = @"";
                if (desc2 ){
                    description2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                }
                
                const unsigned char *desc3 = sqlite3_column_text(compiledStatement, 3);
                NSString *description3 = @"";
                if (desc3){
                    description3 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                }
                
                NSNumber *longitudeValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 4)];
                NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithDecimal:[longitudeValue decimalValue]];
                NSNumber *latitudeValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 5)];
                NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithDecimal:[latitudeValue decimalValue]];
                
                const unsigned char *add = sqlite3_column_text(compiledStatement, 6);
                NSString *address = @"";
                if (add){
                    address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                }
                
                const unsigned char *ph = sqlite3_column_text(compiledStatement, 7);
                NSString *phone = @"";
                if (ph){
                    phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                }
                
                const unsigned char *ws = sqlite3_column_text(compiledStatement, 8);
                NSString *website = @"";
                if (ws){
                    website = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                }
                
                NSString *drinkBrief = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                
                const unsigned char *talink = sqlite3_column_text(compiledStatement, 10);
                NSString *link = @"";
                if (talink ){
                    link = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                }
                
                const unsigned char *fb = sqlite3_column_text(compiledStatement, 11);
                NSString *facebook = @"";
                if (fb){
                    facebook = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                }
                
                const unsigned char *ig = sqlite3_column_text(compiledStatement, 12);
                NSString *insta = @"";
                if (ig){
                    insta = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                }
                
                const unsigned char *oh = sqlite3_column_text(compiledStatement, 13);
                NSString *opening = @"";
                if (oh){
                    opening = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)];
                }
                
                const unsigned char *gt = sqlite3_column_text(compiledStatement, 14);
                NSString *getting = @"";
                if (gt){
                    getting = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
                }
                
                const unsigned char *cs = sqlite3_column_text(compiledStatement, 15);
                NSString *closest = @"";
                if (cs){
                    closest = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)];
                }
                
                const unsigned char *tw = sqlite3_column_text(compiledStatement, 16);
                NSString *twURL = @"";
                if (tw){
                    closest = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 16)];
                }
                
                Drink *drink = [[Drink alloc] initWithData:name ddesc:desc ddesc2:description2 ddesc3:description3 dadd:address web:website lon:longitude lat:latitude phoneNumber:phone brief:drinkBrief face:facebook tal:link opening:opening insta:insta getting:getting closest:closest twitter:twURL];
                [drinks addObject:drink];
            }
        }
    }
    return drinks;
}

// Get All Rooms details
- (NSArray *)getAllRooms
{
    sqlite3 *database;
    NSMutableArray *rooms = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStatement;
        NSString *sqlQuery = @"select * from Rooms";
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *roomType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *price = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
                Room *room = [[Room alloc] initWithData:roomType description:description pr:price];
                [rooms addObject:room];
            }
        }
    }
    return rooms;
}

// Get All Transport details
- (NSArray *)getAllTransport
{
    sqlite3 *database;
    NSMutableArray *transports = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStatement;
        NSString *sqlQuery = @"select * from Transport";
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *blurb = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
                const unsigned char *desc2 = sqlite3_column_text(compiledStatement, 3);
                NSString *description2 = @"";
                if(desc2){
                    description2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                }
                
                const unsigned char *desc3 = sqlite3_column_text(compiledStatement, 4);
                NSString *description3 = @"";
                if(desc3){
                    description3 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                }
                
                const unsigned char *desc4 = sqlite3_column_text(compiledStatement, 5);
                NSString *description4 = @"";
                if(desc4){
                    description4 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                }
                
                const unsigned char *desc5 = sqlite3_column_text(compiledStatement, 6);
                NSString *description5 = @"";
                if(desc5){
                    description5 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                }
                
                const unsigned char *desc6 = sqlite3_column_text(compiledStatement, 7);
                NSString *description6 = @"";
                if(desc6){
                    description6 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                }
                
                const unsigned char *desc7 = sqlite3_column_text(compiledStatement, 8);
                NSString *description7 = @"";
                if(desc7){
                    description7 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                }
                
                const unsigned char *desc8 = sqlite3_column_text(compiledStatement, 9);
                NSString *description8 = @"";
                if(desc8){
                    description8 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                }
                
                Transport *transport = [[Transport alloc] initWithData:name bl:blurb d1:description d2:description2 d3:description3 d4:description4 d5:description5 d6:description6 d7:description7 d8:description8];
                [transports addObject:transport];
            }
        }
    }
    return transports;
}

// Get All Travel Tip
- (NSArray *)getTravelTips
{
    sqlite3 *database;
    NSMutableArray *travelTips = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStatement;
        NSString *sqlQuery = @"select * from TravelTips";
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                
                TravelTip *tip = [[TravelTip alloc] initWithData:name desc:description];
                [travelTips addObject:tip];
            }
        }
    }
    return travelTips;
}

// Get All Network details
- (NSArray *)getNetworks
{
    sqlite3 *database;
    NSMutableArray *networks = [[NSMutableArray alloc] init];

    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStatement;
        NSString *sqlQuery = @"select * from Network";
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;

        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *networkBrief = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *imageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *storeLink = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];

                Network *network = [[Network alloc] initWithData:name brief:networkBrief iName:imageName sLink:storeLink];
                [networks addObject:network];
            }
        }
    }
    return networks;
}


// Get All Activities details
- (NSArray *)getAllActivities
{
    sqlite3 *database;
    NSMutableArray *activities = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStatement;
        NSString *sqlQuery = @"select * from Attraction";
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                
                const unsigned char *desc2 = sqlite3_column_text(compiledStatement, 2);
                NSString *description2 = @"";
                if(desc2){
                    description2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                }
                
                const unsigned char *desc3 = sqlite3_column_text(compiledStatement, 3);
                NSString *description3 = @"";
                if(desc3){
                    description3 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                }
                
                NSNumber *longitudeValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 4)];
                NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithDecimal:[longitudeValue decimalValue]];

                NSNumber *latitudeValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 5)];
                NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithDecimal:[latitudeValue decimalValue]];

                const unsigned char *add = sqlite3_column_text(compiledStatement, 6);
                NSString *address = @"";
                if (add){
                    address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                }
                
                const unsigned char *ph = sqlite3_column_text(compiledStatement, 7);
                NSString *phone = @"";
                if (ph){
                    phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                }
                
                const unsigned char *web = sqlite3_column_text(compiledStatement, 8);
                NSString *website = @"";
                if (web){
                    address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                }
                
                NSString *brief = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                
                const unsigned char *talink = sqlite3_column_text(compiledStatement, 10);
                NSString *tlink = @"";
                if (talink ){
                    tlink = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                }
                
                const unsigned char *insta = sqlite3_column_text(compiledStatement, 11);
                NSString *instagram = @"";
                if (insta){
                    instagram = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                }
                
                const unsigned char *open = sqlite3_column_text(compiledStatement, 12);
                NSString *openingHours = @"";
                if (open){
                    openingHours = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                }
                
                const unsigned char *get = sqlite3_column_text(compiledStatement, 13);
                NSString *gettingThere = @"";
                if (get){
                    gettingThere = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)];
                }
                
                const unsigned char *cpt = sqlite3_column_text(compiledStatement, 14);
                NSString *closest = @"";
                if (cpt){
                    closest = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
                }
                
                const unsigned char *face = sqlite3_column_text(compiledStatement, 15);
                NSString *fbook = @"";
                if (face){
                    fbook = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)];
                }
                
                const unsigned char *twit = sqlite3_column_text(compiledStatement, 16);
                NSString *twitter = @"";
                if (twit){
                    twitter = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 16)];
                }
                
                Activity *activity = [[Activity alloc] initWithData:name ddesc:description ddesc2:description2 ddesc3:description3 ddadd:address web:website lon:longitude lat:latitude phoneNumber:phone brie:brief tal:tlink insta:instagram open:openingHours getting:gettingThere stop:closest face:fbook twit:twitter];
                [activities addObject:activity];
            }
        }
    }
    return activities;
}

// Get All Hostel Details details
- (Detail *)getHostelDetails
{
    sqlite3 *database;
    Detail *details;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStatement;
        NSString *sqlQuery = @"select * from HostelDetails";
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                NSString *desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                
                NSString *phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
                NSString *add = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                
                NSString *email = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                
                NSString *website = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                
                NSNumber *lonValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 6)];
                
                NSNumber *latValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 7)];
                
                const unsigned char *book = sqlite3_column_text(compiledStatement, 8);
                NSString *bookingURL = @"";
                if (book ){
                    bookingURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                }
                
                // Trip
                const unsigned char *trip = sqlite3_column_text(compiledStatement, 9);
                NSString *tripURL = @"";
                if (trip){
                    tripURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                }
                
                // Insta
                const unsigned char *insta = sqlite3_column_text(compiledStatement, 10);
                NSString *instagramURL = @"";
                if (insta ){
                    instagramURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                }
                
                // Face
                const unsigned char *face = sqlite3_column_text(compiledStatement, 11);
                NSString *facebookURL = @"";
                if (face){
                    facebookURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                }
                
                NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithDecimal:[lonValue decimalValue]];

                NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithDecimal:[latValue decimalValue]];
                
                details = [[Detail alloc] initWithData:name ddesc:desc dph:phone dadd:add dem:email web:website lon:longitude lat:latitude book:bookingURL ta:tripURL ig:instagramURL fb:facebookURL];
            }
        }
    }
    return details;
}

#pragma Data Methods

// Method to get the steps for a specific object
- (NSArray *)getStepsForObject:(NSString *)name
{
    sqlite3 *database;
    NSMutableArray *steps = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStatement;
        NSString *sqlQuery = [NSString stringWithFormat:@"select * from Steps where name = '%@';", name];
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *stepValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSNumber *orderValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 2)];
                NSInteger order = [orderValue integerValue];
                
                Step *step = [[Step alloc] initWithData:name step:stepValue order:order];
                
                [steps addObject:step];
            }
        }
    }
    return steps;
}

// Method to get a specific food by name
- (Food *)getFoodByName:(NSString *)name
{
    sqlite3 *database;
    Food *food;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStatement;
        NSString *sqlQuery = [NSString stringWithFormat:@"select * from Food where name = '%@';", name];
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
        
                NSNumber *longitudeValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 3)];
                NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithDecimal:[longitudeValue decimalValue]];
                NSNumber *latitudeValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 4)];
                NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithDecimal:[latitudeValue decimalValue]];
                
                const unsigned char *add = sqlite3_column_text(compiledStatement, 5);
                NSString *address = @"";
                if (add){
                    address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                }
                
                const unsigned char *ph = sqlite3_column_text(compiledStatement, 6);
                NSString *phone = @"";
                if (ph){
                    phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                }
                
                const unsigned char *ws = sqlite3_column_text(compiledStatement, 7);
                NSString *website = @"";
                if (ws){
                    website = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                }
                
                NSString *brief = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                
                const unsigned char *oh = sqlite3_column_text(compiledStatement, 9);
                NSString *openingHours = @"";
                if (oh){
                    openingHours = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                }
                
                const unsigned char *talink = sqlite3_column_text(compiledStatement, 10);
                NSString *link = @"";
                if (talink ){
                    link = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                }
                
                const unsigned char *ig = sqlite3_column_text(compiledStatement, 11);
                NSString *iURL = @"";
                if (ig){
                    iURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                }
                
                const unsigned char *fb = sqlite3_column_text(compiledStatement, 12);
                NSString *fURL = @"";
                if (fb){
                    fURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                }
                
                food = [[Food alloc] initWithData:type nm:name ddesc:desc dadd:address web:website lon:longitude lat:latitude phoneNumber:phone br:brief open:openingHours tal:link insta:iURL face:fURL];
            }
        }
    }
    return food;
}

// Method to get a specific drink by name
- (Drink *)getDrinkByName:(NSString *)name
{
    sqlite3 *database;
    Drink *drink;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStatement;
        NSString *sqlQuery = [NSString stringWithFormat:@"select * from Drink where name = '%@';", name];
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                
                const unsigned char *desc2 = sqlite3_column_text(compiledStatement, 2);
                NSString *description2 = @"";
                if (desc2 ){
                    description2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                }
                
                const unsigned char *desc3 = sqlite3_column_text(compiledStatement, 3);
                NSString *description3 = @"";
                if (desc3){
                    description3 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                }
                
                NSNumber *longitudeValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 4)];
                NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithDecimal:[longitudeValue decimalValue]];
                NSNumber *latitudeValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 5)];
                NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithDecimal:[latitudeValue decimalValue]];
                
                const unsigned char *add = sqlite3_column_text(compiledStatement, 6);
                NSString *address = @"";
                if (add){
                    address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                }
                
                const unsigned char *ph = sqlite3_column_text(compiledStatement, 7);
                NSString *phone = @"";
                if (ph){
                    phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                }
                
                const unsigned char *ws = sqlite3_column_text(compiledStatement, 8);
                NSString *website = @"";
                if (ws){
                    website = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                }
                
                NSString *drinkBrief = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                
                const unsigned char *talink = sqlite3_column_text(compiledStatement, 10);
                NSString *link = @"";
                if (talink ){
                    link = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                }
                
                const unsigned char *fb = sqlite3_column_text(compiledStatement, 11);
                NSString *facebook = @"";
                if (fb){
                    facebook = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                }
                
                const unsigned char *ig = sqlite3_column_text(compiledStatement, 12);
                NSString *insta = @"";
                if (ig){
                    insta = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                }
                
                const unsigned char *oh = sqlite3_column_text(compiledStatement, 13);
                NSString *opening = @"";
                if (oh){
                    opening = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)];
                }
                
                const unsigned char *gt = sqlite3_column_text(compiledStatement, 14);
                NSString *getting = @"";
                if (gt){
                    getting = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
                }
                
                const unsigned char *cs = sqlite3_column_text(compiledStatement, 15);
                NSString *closest = @"";
                if (cs){
                    closest = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)];
                }
                
                const unsigned char *tw = sqlite3_column_text(compiledStatement, 16);
                NSString *twURL = @"";
                if (tw){
                    closest = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 16)];
                }
                
                drink = [[Drink alloc] initWithData:name ddesc:desc ddesc2:description2 ddesc3:description3 dadd:address web:website lon:longitude lat:latitude phoneNumber:phone brief:drinkBrief face:facebook tal:link opening:opening insta:insta getting:getting closest:closest twitter:twURL];
            }
        }
    }
    return drink;
}

// Method to get a specific room by name
- (Room *)getRoomByName:(NSString *)name
{
    sqlite3 *database;
    Room *room;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStatement;
        NSString *sqlQuery = [NSString stringWithFormat:@"select * from Rooms where roomType = '%@';", name];
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *roomType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *price = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
                room = [[Room alloc] initWithData:roomType description:description pr:price];
            }
        }
    }
    return room;
}

// Method to get a specific activity by name
- (Activity *)getActivityByName:(NSString *)name
{
    sqlite3 *database;
    Activity *activity;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStatement;
        NSString *sqlQuery = [NSString stringWithFormat:@"select * from Attraction where name = '%@';", name];
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                
                const unsigned char *desc2 = sqlite3_column_text(compiledStatement, 2);
                NSString *description2 = @"";
                if(desc2){
                    description2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                }
                
                const unsigned char *desc3 = sqlite3_column_text(compiledStatement, 3);
                NSString *description3 = @"";
                if(desc3){
                    description3 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                }
                
                NSNumber *longitudeValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 4)];
                NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithDecimal:[longitudeValue decimalValue]];
                
                NSNumber *latitudeValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 5)];
                NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithDecimal:[latitudeValue decimalValue]];
                
                const unsigned char *add = sqlite3_column_text(compiledStatement, 6);
                NSString *address = @"";
                if (add){
                    address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                }
                
                const unsigned char *ph = sqlite3_column_text(compiledStatement, 7);
                NSString *phone = @"";
                if (ph){
                    phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                }
                
                const unsigned char *web = sqlite3_column_text(compiledStatement, 8);
                NSString *website = @"";
                if (web){
                    address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                }
                
                NSString *brief = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                
                const unsigned char *talink = sqlite3_column_text(compiledStatement, 10);
                NSString *tlink = @"";
                if (talink ){
                    tlink = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                }
                
                const unsigned char *insta = sqlite3_column_text(compiledStatement, 11);
                NSString *instagram = @"";
                if (insta){
                    instagram = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                }
                
                const unsigned char *open = sqlite3_column_text(compiledStatement, 12);
                NSString *openingHours = @"";
                if (open){
                    openingHours = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                }
                
                const unsigned char *get = sqlite3_column_text(compiledStatement, 13);
                NSString *gettingThere = @"";
                if (get){
                    gettingThere = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 13)];
                }
                
                const unsigned char *cpt = sqlite3_column_text(compiledStatement, 14);
                NSString *closest = @"";
                if (cpt){
                    closest = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 14)];
                }
                
                const unsigned char *face = sqlite3_column_text(compiledStatement, 15);
                NSString *fbook = @"";
                if (face){
                    fbook = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)];
                }
                
                const unsigned char *twit = sqlite3_column_text(compiledStatement, 16);
                NSString *twitter = @"";
                if (twit){
                    twitter = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 16)];
                }
                
                activity = [[Activity alloc] initWithData:name ddesc:description ddesc2:description2 ddesc3:description3 ddadd:address web:website lon:longitude lat:latitude phoneNumber:phone brie:brief tal:tlink insta:instagram open:openingHours getting:gettingThere stop:closest face:fbook twit:twitter];
            }
        }
    }
    return activity;
}

// Method to get a specific photos for a specific area. Integer indicates which file if there are more than one
- (NSArray *)getPhotoNames:(NSString *)area identifier:(NSString *)idt
{
    sqlite3 *database;
    NSMutableArray *photoNames = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        // NEED TO DETERMINE IF A ' exists
        NSString *value = @"";
        NSRange range = [idt rangeOfString:@"'"];
        if (range.location != NSNotFound)
        {
            NSArray *myArray = [idt componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"'"]];
            value = [NSString stringWithFormat:@"%@''%@", myArray[0], myArray[1]];
        } else {
            value = idt;
        }
        
        const char *sqlStatement;
        NSString *sqlQuery = [NSString stringWithFormat:@"select * from PhotoLookup where area = '%@' and ID = '%@'order by OrderNumber;", area, value];
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *areaValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *identifier = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *photoName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSNumber *orderValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 3)];
                NSInteger order = [orderValue intValue];
                
                PhotoLookup *pl = [[PhotoLookup alloc] initWithData:areaValue identifier:identifier namw:photoName order:order];
                [photoNames addObject:pl];
            }
        }
    }
    return photoNames;
}

// Method to get a specific thumbnail photos for a specific area. Integer indicates which file if there are more than one
- (NSArray *)getThumbnailNames:(NSString *)area
{
    sqlite3 *database;
    NSMutableArray *photoNames = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
//        // NEED TO DETERMINE IF A ' exists
//        NSString *value = @"";
//        NSRange range = [idt rangeOfString:@"'"];
//        if (range.location != NSNotFound)
//        {
//            NSArray *myArray = [idt componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"'"]];
//            value = [NSString stringWithFormat:@"%@''%@", myArray[0], myArray[1]];
//        } else {
//            value = idt;
//        }
        
        const char *sqlStatement;
        NSString *sqlQuery = [NSString stringWithFormat:@"select * from ThumbnailLookup where area = '%@'order by OrderNumber;", area];
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *areaValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *identifier = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *photoName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSNumber *orderValue = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, 3)];
                NSInteger order = [orderValue intValue];
                
                PhotoLookup *pl = [[PhotoLookup alloc] initWithData:areaValue identifier:identifier namw:photoName order:order];
                [photoNames addObject:pl];
            }
        }
    }
    return photoNames;
}

// Method to get all the facilities
- (NSArray *)getFacilities
{
    sqlite3 *database;
    NSMutableArray *facilities = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStatement;
        NSString *sqlQuery = @"select * from Facilities";
        sqlStatement = [sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                NSString *facility = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                [facilities addObject:facility];
            }
        }
    }
    return facilities;
}

@end

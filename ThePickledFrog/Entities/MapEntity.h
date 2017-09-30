//
//  MapEntitiy.h
//
//  Created by Ashley Templeman on 24/02/2016.
//  Copyright © 2016 Keep It Simple Travel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapEntity : NSObject
{
    
}
@property(nonatomic, copy) NSString *name;
@property(nonatomic, retain) NSDecimalNumber *longitude;
@property(nonatomic, retain) NSDecimalNumber *latitude;
@property (nonatomic, assign) NSInteger type;

-(id)initWithData:(NSString *)name lon:(NSDecimalNumber *)lo lat:(NSDecimalNumber *)la ty:(NSInteger)typ;
@end
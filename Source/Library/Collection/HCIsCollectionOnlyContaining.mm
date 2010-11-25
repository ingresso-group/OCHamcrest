//
//  OCHamcrest - HCIsCollectionOnlyContaining.mm
//  Copyright 2009 www.hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

    // Self
#import "HCIsCollectionOnlyContaining.h"

    // OCHamcrest
#import "HCAnyOf.h"
#import "HCDescription.h"
#import "HCWrapInMatcher.h"


@implementation HCIsCollectionOnlyContaining

+ (HCIsCollectionOnlyContaining*) isCollectionOnlyContaining:(id<HCMatcher>)aMatcher
{
    return [[[HCIsCollectionOnlyContaining alloc] initWithMatcher:aMatcher] autorelease];
}


- (id) initWithMatcher:(id<HCMatcher>)aMatcher
{
    self = [super init];
    if (self != nil)
        matcher = [aMatcher retain];
    return self;
}


- (void) dealloc
{
    [matcher release];
    
    [super dealloc];
}


- (BOOL) matches:(id)collection
{
    if (![collection conformsToProtocol:@protocol(NSFastEnumeration)])
        return NO;
    
    if ([collection count] == 0)
        return NO;
    
    for (id item in collection)
    {
        if (![matcher matches:item])
            return NO;
    }
    return YES;
}


- (void) describeTo:(id<HCDescription>)description
{
    [[description appendText:@"a collection containing items matching "]
                    appendDescriptionOf:matcher];
}

@end


OBJC_EXPORT id<HCMatcher> HC_onlyContains(id item, ...)
{
    NSMutableArray* matcherList = [NSMutableArray arrayWithObject:HCWrapInMatcher(item)];
    
    va_list args;
    va_start(args, item);
    item = va_arg(args, id);
    while (item != nil)
    {
        [matcherList addObject:HCWrapInMatcher(item)];
        item = va_arg(args, id);
    }
    va_end(args);
    
    return [HCIsCollectionOnlyContaining isCollectionOnlyContaining:[HCAnyOf anyOf:matcherList]];
}

//
//  Serializable.m
//  Serializable
//
//  Created by Роман on 11/28/15.
//  Copyright © 2015 Roman. All rights reserved.
//

#import "Serializable.h"

#import <objc/runtime.h>

@implementation Serializable

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        _ignoredProperties = @[];
    }
    
    return self;
}

#pragma mark - NSCoping

- (instancetype) copyWithZone: (NSZone*)zone
{
    Serializable* newObject = [[[self class] allocWithZone: zone] init];
    
    NSArray* propertiesNames = [self propertiesNames];
    
    for (NSString* propertyName in propertiesNames)
    {
        [newObject setValue: [[self valueForKey: propertyName] copy] forKey: propertyName];
    }
    
    return newObject;
}

- (instancetype) mutableCopyWithZone: (NSZone*)zone
{
    return [self copyWithZone: zone];
}

#pragma mark - NSCoding

- (instancetype) initWithCoder: (NSCoder*)decoder
{
    self = [super init];
    if (self)
    {
        NSArray* propertiesNames = [self propertiesNames];
        
        for (NSString* propertyName in propertiesNames)
        {
            id propertyValue = [decoder decodeObjectForKey: propertyName];
            [self setValue: propertyValue forKey: propertyName];
        }
    }
    
    return self;
}

- (void) encodeWithCoder: (NSCoder*)coder
{
    NSArray* propertiesNames = [self propertiesNames];
    
    for (NSString* propertyName in propertiesNames)
    {
        [coder encodeObject: [self valueForKey: propertyName] forKey: propertyName];
    }
}

#pragma mark - private

- (NSArray*) propertiesNames
{
    NSMutableArray* propertiesNSArray = [NSMutableArray array];
    
    unsigned int propertiesCount = 0;
    objc_property_t* properties = class_copyPropertyList([self class], &propertiesCount);
    for(int i = 0; i < propertiesCount; i++)
    {
        objc_property_t property = properties[i];
        const char* propertyName = property_getName(property);
        if(propertyName)
        {
            [propertiesNSArray addObject: [NSString stringWithUTF8String: propertyName]];
        }
    }

    free(properties);
    
    return propertiesNSArray;
}

@end

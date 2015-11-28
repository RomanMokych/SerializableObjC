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

- (BOOL) isEqual: (id)object
{
    if (![object isKindOfClass: [self class]])
    {
        return NO;
    }
    
    NSArray* propertiesNames = [self filteredPropertiesNames];
    
    for (NSString* propertyName in propertiesNames)
    {
        id propertyValueA = [self valueForKey: propertyName];
        id propertyValueB = [object valueForKey: propertyName];
        
        if (propertyValueA == nil && propertyValueB == nil)
        {
            continue;
        }
        
        if (![propertyValueA isEqual: propertyValueB])
        {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - NSCoping

- (instancetype) copyWithZone: (NSZone*)zone
{
    Serializable* newObject = [[[self class] allocWithZone: zone] init];
    
    NSArray* propertiesNames = [self filteredPropertiesNames];
    
    for (NSString* propertyName in propertiesNames)
    {
        id propertyValue = [self valueForKey: propertyName];
        if (propertyValue)
        {
            [newObject setValue: [propertyValue copy] forKey: propertyName];
        }
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
        NSArray* propertiesNames = [self filteredPropertiesNames];
        
        for (NSString* propertyName in propertiesNames)
        {
            id propertyValue = [decoder decodeObjectForKey: propertyName];
            if (propertyValue)
            {
                [self setValue: propertyValue forKey: propertyName];
            }
        }
    }
    
    return self;
}

- (void) encodeWithCoder: (NSCoder*)coder
{
    NSArray* propertiesNames = [self filteredPropertiesNames];
    
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

- (NSArray*) filteredPropertiesNames
{
    NSArray* propertiesNames = [self propertiesNames];
    NSMutableArray* filteredPropertiesNames = [NSMutableArray array];
    for (NSString* propertyName in propertiesNames)
    {
        if (![_ignoredProperties containsObject: propertyName])
        {
            [filteredPropertiesNames addObject: propertyName];
        }
    }
    
    return filteredPropertiesNames;
}

@end

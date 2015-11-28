//
//  Serializable.h
//  Serializable
//
//  Created by Роман on 11/28/15.
//  Copyright © 2015 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Serializable : NSObject<NSCoding>

- (instancetype) init;

@property (nonatomic, copy) NSArray* ignoredProperties; //NSString*

@end

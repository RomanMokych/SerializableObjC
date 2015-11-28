//
//  SerializableTests.m
//  SerializableTests
//
//  Created by Роман on 11/28/15.
//  Copyright © 2015 Roman. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Serializable.h"

@interface SerializableA : Serializable

@property (nonatomic, strong) NSString* aString;
@property (nonatomic) BOOL aBool;
@property (nonatomic) int aInt;

@end

@implementation SerializableA
@end

@interface SerializableTests : XCTestCase

@end

@implementation SerializableTests

- (void)test_Archiving
{
    SerializableA* a = [[SerializableA alloc] init];
    a.aString = @"test";
    a.aBool = YES;
    a.aInt = 5;
    
    NSData* aData = [NSKeyedArchiver archivedDataWithRootObject: a];
    
    SerializableA* b = [NSKeyedUnarchiver unarchiveObjectWithData: aData];
    
    XCTAssertEqualObjects(@"test", b.aString);
    XCTAssertEqual(YES, b.aBool);
    XCTAssertEqual(5, b.aInt);
}

- (void)test_Copying
{
    SerializableA* a = [[SerializableA alloc] init];
    a.aString = @"test";
    a.aBool = YES;
    a.aInt = 5;
    
    SerializableA* b = [a copy];
    
    XCTAssertEqualObjects(@"test", b.aString);
    XCTAssertEqual(YES, b.aBool);
    XCTAssertEqual(5, b.aInt);
}

- (void)test_MutableCopying
{
    SerializableA* a = [[SerializableA alloc] init];
    a.aString = @"test";
    a.aBool = YES;
    a.aInt = 5;
    
    SerializableA* b = [a mutableCopy];
    
    XCTAssertEqualObjects(@"test", b.aString);
    XCTAssertEqual(YES, b.aBool);
    XCTAssertEqual(5, b.aInt);
}

@end

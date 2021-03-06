//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2016 Jonathan M. Reid. See LICENSE.txt
//  Contribution by Igor Sales

#import "OCMockito.h"

#import <OCHamcrest/OCHamcrest.h>
#import <XCTest/XCTest.h>


@interface StubSingletonTests : XCTestCase
@end

@implementation StubSingletonTests
{
    __strong Class mockUserDefaultsClass;
}

- (void)setUp
{
    [super setUp];
    mockUserDefaultsClass = mockClass([NSUserDefaults class]);
}

- (void)tearDown
{
    mockUserDefaultsClass = nil;
    [super tearDown];
}

- (void)testStubbedSingleton_ShouldReturnGivenObject
{
    stubSingleton(mockUserDefaultsClass, standardUserDefaults);
    [given([mockUserDefaultsClass standardUserDefaults]) willReturn:@"STUBBED"];
    
    assertThat([NSUserDefaults standardUserDefaults], is(@"STUBBED"));
}

- (void)testStubbedSingleton_ShouldReturnGivenObject_SO_NAMED_TO_EXECUTE_AFTER_TEST_ABOVE_EnsureThatMockDeallocationRestoresOriginalSingleton
{
    assertThat([NSUserDefaults standardUserDefaults], is(instanceOf([NSUserDefaults class])));
}

- (void)testExplicitlyStopMocking_ClassWithStubbedSingleton_ShouldReturnOriginalSingleton
{
    stubSingleton(mockUserDefaultsClass, standardUserDefaults);
    [given([mockUserDefaultsClass standardUserDefaults]) willReturn:@"STUBBED"];
    
    stopMocking(mockUserDefaultsClass);
    
    assertThat([NSUserDefaults standardUserDefaults], is(instanceOf([NSUserDefaults class])));
}

- (void)testStubbedSingleton_WithMultipleStubs_ShouldGivePrecedenceToLastStub
{
    stubSingleton(mockUserDefaultsClass, standardUserDefaults);
    [given([mockUserDefaultsClass standardUserDefaults]) willReturn:@"STUBBED"];
    
    __strong Class secondMockClass = mockClass([NSUserDefaults class]);
    stubSingleton(secondMockClass, standardUserDefaults);
    [given([secondMockClass standardUserDefaults]) willReturn:@"STUBBED2"];
    
    assertThat([NSUserDefaults standardUserDefaults], is(@"STUBBED2"));
}

- (void)testExplicitlyStop_WithMultipleStubs_ShouldReturnOriginalSingleton
{
    stubSingleton(mockUserDefaultsClass, standardUserDefaults);
    [given([mockUserDefaultsClass standardUserDefaults]) willReturn:@"STUBBED"];
    
    __strong Class secondMockClass = mockClass([NSUserDefaults class]);
    stubSingleton(secondMockClass, standardUserDefaults);
    [given([secondMockClass standardUserDefaults]) willReturn:@"STUBBED2"];
    
    stopMocking(mockUserDefaultsClass);
    stopMocking(secondMockClass);
    
    assertThat([NSUserDefaults standardUserDefaults], is(instanceOf([NSUserDefaults class])));
}

@end

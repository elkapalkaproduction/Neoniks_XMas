//
//  NNKObjectParameters.h
//  halloween
//
//  Created by Andrei Vidrasco on 8/3/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNKObjectState.h"

@interface NNKObjectParameters : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (assign, nonatomic) Class type;
@property (strong, nonatomic) NSArray *animationImages;
@property (assign, nonatomic) CGRect frame;
- (NNKObjectState *)stateAtIndex:(NSInteger)index;
- (NSInteger)statesCount;

@end

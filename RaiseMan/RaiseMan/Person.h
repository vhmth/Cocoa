//
//  Person.h
//  RaiseMan
//
//  Created by Vinay Siddharam Hiremath on 3/16/13.
//  Copyright (c) 2013 Underpull. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCoding> {
    NSString *name;
    float expectedRaise;
}
@property (readwrite, copy) NSString *name;
@property (readwrite) float expectedRaise;
@end
//
//  main.m
//  TESTMYCAIXIANG
//
//  Created by cheng on 2017/6/11.
//  Copyright © 2017年 COOPER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "a.h"
#import "b.h"
int main(int argc, const char * argv[]) {
    a* newa = [[a alloc] init];
    NSMutableArray* newArray = [[NSMutableArray alloc] init];
//    [newArray addObject:s];
    newa.Date = newArray;
    NSString* t = @"aDateTypsssse";
    [newa.Date addObject:t];
    [newa.Date addObject:@"2"];
    
    NSLog(@"%@what",newa.Date[1]);
    return 0;
}

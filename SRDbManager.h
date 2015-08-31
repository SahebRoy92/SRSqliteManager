//
//  SRDbManager.h
//  Hashwell
//
//  Created by Admin on 20/08/15.
//  Copyright (c) 2015 OFTL. All rights reserved.
//


#define DATABASENAME @"UntitledGame.sqlite"

#import <Foundation/Foundation.h>

@interface SRDbManager : NSObject

+(BOOL)initializeDatabase;
+(NSMutableArray *)readQuery:(NSString *)query;

@end

//
//  SRDbManager.m
//  Hashwell
//
//  Created by Admin on 20/08/15.
//  Copyright (c) 2015 OFTL. All rights reserved.
//

#import "SRDbManager.h"
#import <sqlite3.h>



@interface SRDbManager ()

@end
static sqlite3 *database;
@implementation SRDbManager


+(BOOL)initializeDatabase{
    
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[path objectAtIndex:0]stringByAppendingString:DATABASENAME];
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileName]){
        
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASENAME];
        NSError *error;
        [[NSFileManager defaultManager]copyItemAtPath:sourcePath toPath:fileName error:&error];
        if(error){
            return NO;
        }
    }
    
    if(sqlite3_open([fileName UTF8String], &database) == SQLITE_OK){
        return YES;
    }
    else {
        NSLog(@"ERROR %s",sqlite3_errmsg(database));
        return NO;
    }
}


+(NSMutableArray *)readQuery:(NSString *)query{
    NSMutableArray *toReturn = [NSMutableArray array];
    
    sqlite3_stmt *compiledStatement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(compiledStatement)==SQLITE_ROW) {
            
            NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
            int numberOfCol = sqlite3_column_count(compiledStatement);
            for (int i=0; i<numberOfCol; i++) {
                
                NSString *columnName = [NSString stringWithUTF8String:(char *)sqlite3_column_name(compiledStatement, i)];
                NSString *columnData;
                
                if((char*)sqlite3_column_text(compiledStatement, i)){
                    columnData = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i)];
                    
                }
                else {
                    columnData = [NSString stringWithFormat:@"%@",[NSNull null]];
                }
                [resultDict setObject:columnData forKey:columnName];
                
            }
            [toReturn addObject:resultDict];
            
        }
            NSLog(@"Success --");
        
    }
    else {
        NSLog(@"Error --%s",sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(compiledStatement);
    return toReturn;
}

+(BOOL)closeConnection{
    if(sqlite3_close(database) == SQLITE_OK){
        return YES;
    }
    else {
        NSLog(@"Error--%s",sqlite3_errmsg(database));
        return NO;
    }
}

@end

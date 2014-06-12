//
//  JDOCommonUtil.h
//  JiaodongOnlineNews
//
//  Created by zhang yi on 13-5-31.
//  Copyright (c) 2013年 胶东在线. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBNoticeView.h"

#define PROTOCOL	@"PROTOCOL"
#define HOST		@"HOST"
#define PARAMS		@"PARAMS"
#define URI1		@"URI"

typedef enum{
    DateFormatYMD,
    DateFormatMD,
    DateFormatYMDHM,
    DateFormatYMDHMS,
    DateFormatMDHM,
    DateFormatHM,
}DateFormatType;

@interface JDHXLUtil : NSObject

+ (void) showFrameDetail:(UIView *)view;
+ (void) showBoundsDetail:(UIView *)view;

+ (NSString *)formatDate:(NSDate *) date withFormatter:(DateFormatType) format;
+ (NSDate *)formatString:(NSString *)date withFormatter:(DateFormatType) format;
+ (NSString*)getChineseCalendarWithDate:(NSDate *)date;

+ (NSString *) formatErrorWithOperation:(AFHTTPRequestOperation *)operation error:(NSError *)error;

+ (NSDictionary *)paramsFromURL:(NSString *)url;

+ (NSURL *)documentsDirectoryURL;
+ (NSURL *)cachesDirectoryURL;
+ (NSURL *)downloadsDirectoryURL;
+ (NSURL *)libraryDirectoryURL;
+ (NSURL *)applicationSupportDirectoryURL;

+ (BOOL) createDiskDirectory:(NSString *)directoryPath;
+ (NSString *) createDetailCacheDirectory:(NSString *)cachePathName;
+ (NSString *) createJDOCacheDirectory;
+ (void) deleteJDOCacheDirectory;
+ (void) deleteURLCacheDirectory;
+ (int) getDiskCacheFileCount;
+ (int) getDiskCacheFileSize;

@end

BOOL JDOIsEmptyString(NSString *string);
BOOL JDOIsNumber(NSString *string);
BOOL JDOIsEmail(NSString *string);

NSString* JDOGetHomeFilePath(NSString *fileName);
NSString* JDOGetTmpFilePath(NSString *fileName);
NSString* JDOGetCacheFilePath(NSString *fileName);
NSString* JDOGetDocumentFilePath(NSString *fileName);
NSString* JDOGetUUID();
BOOL JDODeleteUUID();

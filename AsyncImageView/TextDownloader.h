//
//  TextDownloader.h
//  Couple
//
//  Created by User on 17.05.13.
//  Copyright (c) 2013 Yula-Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextDownloader : NSObject
{
    BOOL fetchingToken;
}

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *responseText;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, copy) void (^completionHandler)(void);

- (id)initWithUrl:(NSString*)url;

- (NSString*)getToken;
- (void)startDownload;
- (void)cancelDownload;
- (BOOL)isDownloading;

@end

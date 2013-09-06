//
//  TextDownloader.m
//  Couple
//
//  Created by User on 17.05.13.
//  Copyright (c) 2013 Yula-Group. All rights reserved.
//

#import "TextDownloader.h"

@interface TextDownloader ()
@property (nonatomic, strong) NSMutableData *activeDownload;
@end


@implementation TextDownloader

#define HOST @"http://lookbook.buram.ru"

#pragma mark

- (id)initWithUrl:(NSString *)url
{
    self = [super init];
    self.urlString = url;
    return self;
}

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    NSString* token = [self getToken];
    if(!token){
        [self fetchToken];
        return;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSLog(@"loading %@", self.urlString);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST, self.urlString]]];
    [request setValue:[NSString stringWithFormat:@"Token %@", token] forHTTPHeaderField:@"Authorization"];
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (NSString*)getToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"token"];
}

- (void)fetchToken
{
    fetchingToken = true;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString* urlString = [NSString stringWithFormat:@"%@/get-token/?user=%@", HOST, [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)cancelDownload
{
    if(self.connection){
        [self.connection cancel];
        self.connection = nil;
        self.activeDownload = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (BOOL)isDownloading
{
    return self.connection != nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    NSLog(@"%@", error);
    
    [[[UIAlertView alloc] initWithTitle:@"Ошибка сети"
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
    
    // Release the connection now that it's finished
    self.connection = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(fetchingToken){
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:self.activeDownload options: NSJSONReadingMutableContainers error:nil];
        NSString *token = [jsonDict objectForKey:@"token"];
        if(!token){
            return;
        }else{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:token forKey:@"token"];
            [defaults synchronize];
        }
    }else{
        self.responseText = [[NSString alloc] initWithData:self.activeDownload encoding:NSUTF8StringEncoding];
        NSLog(@"response %@", self.responseText);
    }
    self.activeDownload = nil;
    
    
    
    // Release the connection now that it's finished
    self.connection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    if(fetchingToken){
        fetchingToken = false;
        [self startDownload];
    }else{
        if (self.completionHandler)
            self.completionHandler();
    }
}

@end


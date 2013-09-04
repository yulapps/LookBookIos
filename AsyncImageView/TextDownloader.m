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
@property (nonatomic, strong) NSURLConnection *connection;
@end


@implementation TextDownloader

#define HOST @"http://lookbook.buram.ru"

#pragma mark

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [defaults objectForKey:@"token"];
    if(!token){
        [self getToken];
        return;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST, self.urlString]]];
    [request addValue:[NSString stringWithFormat:@"Token %@", token] forHTTPHeaderField:@"Authorization"];
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)getToken
{
    fetchingToken = true;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString* urlString = [NSString stringWithFormat:@"%@/get-token/?user=%@", HOST, [[UIDevice currentDevice] identifierForVendor]];
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


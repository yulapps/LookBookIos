//
//  YAPhotoViewController.m
//  LookBook
//
//  Created by User on 02.09.13.
//  Copyright (c) 2013 Yula-Group. All rights reserved.
//

#import "YAPhotoViewController.h"
#import "AsyncImageView.h"

#define HOST @"http://lookbook.buram.ru"

@interface YAPhotoViewController ()

@end

@implementation YAPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!imageViews) imageViews = [NSMutableArray array];
    if(!textDownloader) textDownloader = [[TextDownloader alloc] init];
	// Do any additional setup after loading the view.
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Photo %d of %d", self.currentImage, self.allImages.count]];
}

- (void)viewDidLayoutSubviews
{
    int width = self.scrollView.frame.size.width - 10;
    int x = self.scrollView.frame.size.width;
    int height = self.scrollView.frame.size.height;
    
    for(int i=0; i<self.allImages.count; ++i){
        AsyncImageView *imageView;
        if(imageViews.count > i){
            imageView = [imageViews objectAtIndex:i];
            [imageView setFrame:CGRectMake(x * i, 0, width, height)];
        }else{
            imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(x * i, 0, width, height)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            //imageView.image = [UIImage imageNamed:[self.allImages objectAtIndex:i]];
            NSDictionary *photoDict = [self.allImages objectAtIndex:i];
            imageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/media/%@", HOST, [photoDict objectForKey:@"photo"]]];
            [self.scrollView addSubview:imageView];
            [imageViews addObject:imageView];
        }
    }
    [self.scrollView setContentSize:CGSizeMake(self.allImages.count * x, height)];
    [self.scrollView setContentOffset:CGPointMake(self.currentImage * x - x, 0)];
}

-(void) showHideNavbar:(id) sender
{
    BOOL navBarHidden = ![self.navigationController isNavigationBarHidden];
    [[self navigationController] setNavigationBarHidden:navBarHidden animated:NO];
    int alpha = navBarHidden ? 0 : 1;
    if(!navBarHidden){
        [self.toolbar setAlpha:0];
        [self.toolbar setHidden:navBarHidden];
    }
    [UIView animateWithDuration:0.25
                     animations:^{self.toolbar.alpha = alpha;}
                     completion:^(BOOL finished){
                         [self.toolbar setHidden:navBarHidden];
                     }];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.allImages && self.allImages.count){
        float offset = self.scrollView.contentOffset.x;
        float width = self.scrollView.frame.size.width;
        self.currentImage = round(offset/width) + 1;
        [self.navigationItem setTitle:[NSString stringWithFormat:@"Photo %d of %d", self.currentImage, self.allImages.count]];
        [self initButtons];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initButtons
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *photoDict = [self.allImages objectAtIndex:self.currentImage - 1];
    NSNumber* pk = [photoDict objectForKey:@"id"];
    NSDictionary* likedPhoto = [defaults objectForKey:[NSString stringWithFormat:@"like_%d", [pk intValue]]];
    if(likedPhoto){
        liked = TRUE;
        self.likeBtn.tintColor = [UIColor colorWithRed:247.0/255 green:119.0/255 blue:23.0/255 alpha:1];
    }else{
        liked = FALSE;
        self.likeBtn.tintColor = [UIColor whiteColor];
    }
}

-(IBAction) home:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction) like:(id)sender
{
    if(liked)
        return;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *photoDict = [self.allImages objectAtIndex:self.currentImage - 1];
    NSNumber* pk = [photoDict objectForKey:@"id"];
    [defaults setObject:photoDict forKey:[NSString stringWithFormat:@"like_%d", [pk intValue]]];
    [defaults synchronize];
    
    NSString* params = [NSString stringWithFormat:@"photo=%d", [pk intValue]];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/like/", HOST]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"Token %@", [textDownloader getToken]] forHTTPHeaderField:@"Authorization"];
    textDownloader.connection = [[NSURLConnection alloc] initWithRequest:request delegate:textDownloader];
    [self initButtons];
}

@end

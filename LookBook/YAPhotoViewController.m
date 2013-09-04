//
//  YAPhotoViewController.m
//  LookBook
//
//  Created by User on 02.09.13.
//  Copyright (c) 2013 Yula-Group. All rights reserved.
//

#import "YAPhotoViewController.h"
#import "AsyncImageView.h"

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
	// Do any additional setup after loading the view.
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Photo %d of %d", self.currentImage, self.allImages.count]];
}

- (void)viewDidLayoutSubviews
{
    int width = self.scrollView.frame.size.width;
    int height = self.scrollView.frame.size.height;
    
    for(int i=0; i<self.allImages.count; ++i){
        AsyncImageView *imageView;
        if(imageViews.count > i){
            imageView = [imageViews objectAtIndex:i];
            [imageView setFrame:CGRectMake(width * i, 0, width, height)];
        }else{
            imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = [UIImage imageNamed:[self.allImages objectAtIndex:i]];
            //imageView.imageURL = [NSURL URLWithString:[self.allImages objectAtIndex:i]];
            [self.scrollView addSubview:imageView];
            [imageViews addObject:imageView];
        }
    }
    [self.scrollView setContentSize:CGSizeMake(self.allImages.count * width, height)];
    [self.scrollView setContentOffset:CGPointMake(self.currentImage * width - width, 0)];
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
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) home:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

//
//  YAPhotoViewController.h
//  LookBook
//
//  Created by User on 02.09.13.
//  Copyright (c) 2013 Yula-Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextDownloader.h"

@interface YAPhotoViewController : UIViewController <UIScrollViewDelegate>
{
    NSMutableArray *imageViews;
    TextDownloader *textDownloader;
    BOOL liked;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *likeBtn;
@property (nonatomic, strong) NSArray *allImages;
@property (nonatomic) NSInteger currentImage;

-(IBAction) home:(id)sender;
-(IBAction) like:(id)sender;

@end

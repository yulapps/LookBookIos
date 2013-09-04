//
//  YAPhotoViewController.h
//  LookBook
//
//  Created by User on 02.09.13.
//  Copyright (c) 2013 Yula-Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YAPhotoViewController : UIViewController <UIScrollViewDelegate>
{
    NSMutableArray *imageViews;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) NSArray *allImages;
@property (nonatomic) NSInteger currentImage;

-(IBAction) home:(id)sender;

@end

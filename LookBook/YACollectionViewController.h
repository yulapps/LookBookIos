//
//  YACollectionViewController.h
//  LookBook
//
//  Created by User on 02.09.13.
//  Copyright (c) 2013 Yula-Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextDownloader.h"

@interface YACollectionViewController : UICollectionViewController
{
    TextDownloader *textDownloader;
    NSMutableArray *photos;
}
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *categoryUrl;

@end

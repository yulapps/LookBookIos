//
//  YAViewController.h
//  LookBook
//
//  Created by User on 02.09.13.
//  Copyright (c) 2013 Yula-Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YAViewController : UIViewController <UICollectionViewDataSource>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end

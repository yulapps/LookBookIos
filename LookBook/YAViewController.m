//
//  YAViewController.m
//  LookBook
//
//  Created by User on 02.09.13.
//  Copyright (c) 2013 Yula-Group. All rights reserved.
//

#import "YAViewController.h"
#import "YACollectionViewController.h"

@interface YAViewController ()

@end

@implementation YAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MenuCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:3];
    switch (indexPath.row) {
        case 0:
            label.text = @"Girls";
            break;
        case 1:
            label.text = @"My Wishlists";
            break;
        case 2:
            label.text = @"Guys";
            break;
        case 3:
            label.text = @"New";
            break;
        case 4:
            label.text = @"Contacts";
            break;
        case 5:
            label.text = @"Hot";
            break;
        default:
            break;
    }

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CategorySegue"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        YACollectionViewController *destViewController = segue.destinationViewController;
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:3];
        destViewController.categoryName = label.text;
    }
}

@end

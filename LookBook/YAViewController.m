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
    categories = [NSArray arrayWithObjects:@"Girls", @"My Wishlists", @"Guys", @"New", @"Hot", nil];
    urls = [NSArray arrayWithObjects:@"/photos/?category=1", @"/wishlists/",  @"/photos/?category=2", @"/new/", @"/hot/", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return categories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MenuCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:3];
    label.text = [categories objectAtIndex:indexPath.row];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CategorySegue"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        YACollectionViewController *destViewController = segue.destinationViewController;
        destViewController.categoryName = [categories objectAtIndex:indexPath.row];
        destViewController.categoryUrl = [urls objectAtIndex:indexPath.row];
    }
}

@end

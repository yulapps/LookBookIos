//
//  YACollectionViewController.m
//  LookBook
//
//  Created by User on 02.09.13.
//  Copyright (c) 2013 Yula-Group. All rights reserved.
//

#import "YACollectionViewController.h"
#import "YAPhotoViewController.h"
#import "AsyncImageView.h"

#define HOST @"http://lookbook.buram.ru/"

@interface YACollectionViewController ()

@end

@implementation YACollectionViewController

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
    
    textDownloader = [[TextDownloader alloc] initWithUrl:self.categoryUrl];
    photos = [NSMutableArray array];
	// Do any additional setup after loading the view.
    [self.navigationItem setTitle:self.categoryName];
    
    YACollectionViewController* this = self;
    if(![self.categoryName isEqualToString:@"My Wishlists"])
    {
        [textDownloader setCompletionHandler:^{
            [this displayData];
        }];
        [textDownloader startDownload];
    }else{
        [self loadFavorites];
    }
    NSLog(@"%@", self.categoryName);
}

- (void) loadFavorites
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *keys = [[defaults dictionaryRepresentation] allKeys];
    for(NSString* key in keys){
        if(key.length < 5)
            continue;
        NSString *prefix = [key substringToIndex:4];
        NSLog(@"prefix %@", prefix);
        if([prefix isEqualToString:@"like"]){
            [photos addObject:[defaults objectForKey:key]];
        }
    }
    [self.collectionView reloadData];
}

- (void) displayData
{
    NSData *data = [textDownloader.responseText dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:nil];
    NSArray *jsonArray = [jsonDict objectForKey:@"results"];
    
    for(int i=0; i<jsonArray.count; ++i){
        [photos addObject:[jsonArray objectAtIndex:i]];
    }
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ImageCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    AsyncImageView *imageView = (AsyncImageView *)[cell viewWithTag:2];
    imageView.crossfadeImages = FALSE;
    
    NSDictionary *photoDict = [photos objectAtIndex:indexPath.row];
    NSArray *array = [[photoDict objectForKey:@"photo"] componentsSeparatedByString:@"."];
    NSMutableArray *prefixArray = [NSMutableArray array];
    for(int i=0; i < prefixArray.count - 1; ++i){
        [prefixArray addObject:[array objectAtIndex:i]];
    }
    NSString *prefix = [prefixArray componentsJoinedByString:@"."];
    [photoDict objectForKey:@"photo"];
    imageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/media/%@.thumbnail.%@", HOST, prefix, [array objectAtIndex:array.count - 1]]];
    //imageView.image = [UIImage imageNamed:@"photo1.jpg"];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        YAPhotoViewController *destViewController = segue.destinationViewController;
        NSLog(@"%@", indexPath);
        destViewController.currentImage = indexPath.row + 1;
        destViewController.allImages = photos;
    }
}

@end

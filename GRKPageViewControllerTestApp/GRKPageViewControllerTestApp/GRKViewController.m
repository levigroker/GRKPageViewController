//
//  GRKViewController.m
//  GRKPageViewController
//
//  Created by Levi Brown on 11/18/13.
//  Copyright (c) 2013 Levi Brown. All rights reserved.
//

#import "GRKViewController.h"

@interface GRKViewController ()

@property (nonatomic,weak) GRKPageViewController *pageViewController;
@property (nonatomic,weak) IBOutlet UISwitch *animatedSwitch;
@property (nonatomic,weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic,weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic,weak) IBOutlet UISlider *pageCountSlider;

- (IBAction)selectPageAction:(UISegmentedControl *)segmentedControl;
- (IBAction)pageControlAction;
- (IBAction)pageCountAction:(UISlider *)sender;

@end

@implementation GRKViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *dest = segue.destinationViewController;
    if ([dest isKindOfClass:GRKPageViewController.class])
    {
        self.pageViewController = (GRKPageViewController *)dest;
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
        [self.pageViewController setCurrentIndex:1 animated:NO];
        [self setup];
    }
}

- (void)setup
{
    [self.pageViewController reloadData];
    NSUInteger pageCount = [self pageCountForPageViewController:self.pageViewController];
    NSUInteger currentIndex = self.pageViewController.currentIndex;
    self.pageControl.numberOfPages = pageCount;
    self.pageControl.currentPage = currentIndex;

    [self.segmentedControl removeAllSegments];
    for (NSInteger i = pageCount; i > 0; --i)
    {
        [self.segmentedControl insertSegmentWithTitle:[NSString stringWithFormat:@"%d", (int)i] atIndex:0 animated:NO];
    }
    self.segmentedControl.selectedSegmentIndex = currentIndex;
}

#pragma mark - Actions

- (IBAction)selectPageAction:(UISegmentedControl *)segmentedControl;
{
    [self.pageViewController setCurrentIndex:segmentedControl.selectedSegmentIndex animated:self.animatedSwitch.on];
}

- (IBAction)pageControlAction
{
    NSInteger currentPage = self.pageControl.currentPage;
    [self.pageViewController setCurrentIndex:(NSUInteger)currentPage animated:self.animatedSwitch.on];
}

- (IBAction)pageCountAction:(UISlider *)sender
{
    [self setup];
}

#pragma mark - GRKPageViewControllerDataSource

- (NSUInteger)pageCountForPageViewController:(GRKPageViewController *)controller
{
    return (NSUInteger)self.pageCountSlider.value;
}

- (UIViewController *)viewControllerForIndex:(NSUInteger)index forPageViewController:(GRKPageViewController *)controller
{
    UIViewController *retVal = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    
    static NSArray *pageColors = nil;
    if (!pageColors)
    {
        pageColors = @[[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor]];
    }
    
    UIColor *color = nil;
    if (index < pageColors.count)
    {
        color = pageColors[index];
    }
    else
    {
        NSLog(@"Page index %lu out of range.", (unsigned long)index);
        CGFloat red = arc4random_uniform(101) / 100.0f;
        CGFloat green = arc4random_uniform(101) / 100.0f;
        CGFloat blue = arc4random_uniform(101) / 100.0f;
        color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    }

    retVal.view.backgroundColor = color;
    
    return retVal;
}

#pragma mark - GRKPageViewControllerDelegate

- (void)changedIndexOffset:(CGFloat)indexOffset forPageViewController:(GRKPageViewController *)controller
{
    NSLog(@"Index Offset: %f", indexOffset);
}

- (void)changedIndex:(NSUInteger)index forPageViewController:(GRKPageViewController *)controller
{
    NSLog(@"Current Index: %lu", (unsigned long)index);
    self.pageControl.currentPage = index;
    self.segmentedControl.selectedSegmentIndex = index;
}

@end

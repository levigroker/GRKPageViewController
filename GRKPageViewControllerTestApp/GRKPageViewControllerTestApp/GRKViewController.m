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

- (IBAction)buttonAction:(UIButton *)button;
- (IBAction)pageControlAction;

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
        self.pageControl.numberOfPages = [self pageCount];
        self.pageControl.currentPage = self.pageViewController.currentIndex;
    }
}

#pragma mark - Actions

- (IBAction)buttonAction:(UIButton *)button
{
    [self.pageViewController setCurrentIndex:button.tag animated:self.animatedSwitch.on];
}

- (IBAction)pageControlAction
{
    NSInteger currentPage = self.pageControl.currentPage;
    [self.pageViewController setCurrentIndex:(NSUInteger)currentPage animated:self.animatedSwitch.on];
}

#pragma mark - GRKPageViewControllerDataSource

- (NSUInteger)pageCount
{
    return 3;
}

- (UIViewController *)viewControllerForIndex:(NSUInteger)index
{
    UIViewController *retVal = [self.storyboard instantiateViewControllerWithIdentifier:@"page"];
    
    switch (index) {
        case 0:
            retVal.view.backgroundColor = [UIColor redColor];
            break;
        case 1:
            retVal.view.backgroundColor = [UIColor orangeColor];
            break;
        case 2:
            retVal.view.backgroundColor = [UIColor yellowColor];
            break;
        default:
            NSLog(@"Page index %lu out of range.", (unsigned long)index);
            break;
    }
    
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
}

@end

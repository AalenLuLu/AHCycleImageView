//
//  ViewController.m
//  AHCycleImageViewDemo
//
//  Created by Aalen on 2017/8/27.
//  Copyright © 2017年 Aalen. All rights reserved.
//

#import "ViewController.h"

#import "AHCycleImageView.h"

@interface ViewController () <AHCycleImageViewDataSource>

@property (strong, nonatomic) NSArray *images;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	AHCycleImageView *imageView = [[AHCycleImageView alloc] initWithFrame: CGRectMake(0, 200, self.view.bounds.size.width, 300)];
//	imageView.dataSource = self;
	[self.view addSubview: imageView];
	
	UIGraphicsBeginImageContext(imageView.bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[[UIColor redColor] setFill];
	CGContextFillRect(context, imageView.bounds);
	
	UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
	
	[[UIColor yellowColor] setFill];
	CGContextFillRect(context, imageView.bounds);
	UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
	
	[[UIColor blueColor] setFill];
	CGContextFillRect(context, imageView.bounds);
	UIImage *image3 = UIGraphicsGetImageFromCurrentImageContext();
	
	[[UIColor grayColor] setFill];
	CGContextFillRect(context, imageView.bounds);
	UIImage *image4 = UIGraphicsGetImageFromCurrentImageContext();
	
	[[UIColor greenColor] setFill];
	CGContextFillRect(context, imageView.bounds);
	UIImage *image5 = UIGraphicsGetImageFromCurrentImageContext();
	
	[[UIColor blackColor] setFill];
	CGContextFillRect(context, imageView.bounds);
	UIImage *image6 = UIGraphicsGetImageFromCurrentImageContext();
	
	[[UIColor cyanColor] setFill];
	CGContextFillRect(context, imageView.bounds);
	UIImage *image7 = UIGraphicsGetImageFromCurrentImageContext();
	
	[[UIColor brownColor] setFill];
	CGContextFillRect(context, imageView.bounds);
	UIImage *image8 = UIGraphicsGetImageFromCurrentImageContext();
	
	[[UIColor orangeColor] setFill];
	CGContextFillRect(context, imageView.bounds);
	UIImage *image9 = UIGraphicsGetImageFromCurrentImageContext();
	
	[[UIColor purpleColor] setFill];
	CGContextFillRect(context, imageView.bounds);
	UIImage *image10 = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	self.images = @[image1, image2, image3, image4, image5, image6, image7, image8, image9, image10];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfItemsInCycleImageView:(AHCycleImageView *)cycleImageView
{
	return _images.count;
}

- (UIImage *)cycleImageView:(AHCycleImageView *)cycleImageView imageForItemAtIndex:(NSInteger)index
{
	return _images[index];
}

@end

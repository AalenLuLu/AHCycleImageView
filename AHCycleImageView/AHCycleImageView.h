//
//  AHCycleImageView.h
//  AHCycleImageViewDemo
//
//  Created by Aalen on 2017/8/27.
//  Copyright © 2017年 Aalen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AHCycleImageView;

@protocol AHCycleImageViewDelegate <NSObject>

- (void)cycleImageView: (AHCycleImageView *)cycleImageView didSelectItemAtIndex: (NSInteger)index;

@end

@protocol AHCycleImageViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInCycleImageView: (AHCycleImageView *)cycleImageView;
- (UIImage *)cycleImageView: (AHCycleImageView *)cycleImageView imageForItemAtIndex: (NSInteger)index;
@optional
- (NSTimeInterval)timeIntervalForCycleImageView: (AHCycleImageView *)cycleImageView;

@end

@interface AHCycleImageView : UIView

@property (weak, nonatomic) id<AHCycleImageViewDelegate> delegate;
@property (weak, nonatomic) id<AHCycleImageViewDataSource> dataSource;

- (void)reloadData;

@end

//
//  AHCycleImageView.m
//  AHCycleImageViewDemo
//
//  Created by Aalen on 2017/8/27.
//  Copyright © 2017年 Aalen. All rights reserved.
//

#import "AHCycleImageView.h"

@interface AHCycleImageView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *currentImageView;
@property (strong, nonatomic) UIImageView *prevImageView;
@property (strong, nonatomic) UIImageView *nextImageView;
@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation AHCycleImageView

- (instancetype)init
{
	return [self initWithFrame: CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		[self addSubview: self.scrollView];
		[_scrollView addSubview: self.prevImageView];
		[_scrollView addSubview: self.nextImageView];
		[_scrollView addSubview: self.currentImageView];
		
		[self addScrollViewConstraints];
	}
	return self;
}

- (void)didMoveToSuperview
{
	if(nil == self.superview)
	{
		[self stopTimer];
	}
	else
	{
		[self startTimer];
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	CGSize scrollViewSize = _scrollView.bounds.size;
	_scrollView.contentSize = CGSizeMake(scrollViewSize.width * 3, scrollViewSize.height);
	_prevImageView.frame = CGRectMake(0, 0, scrollViewSize.width, scrollViewSize.height);
	_currentImageView.frame = CGRectMake(scrollViewSize.width, 0, scrollViewSize.width, scrollViewSize.height);
	_nextImageView.frame = CGRectMake(scrollViewSize.width * 2, 0, scrollViewSize.width, scrollViewSize.height);
}

#pragma mark interface..

- (void)reloadData
{
	NSInteger itemCount = [_dataSource numberOfItemsInCycleImageView: self];
	if(0 == itemCount)
	{
		_currentImageView.image = nil;
		_prevImageView.image = nil;
		_nextImageView.image = nil;
		return;
	}
	[self update];
}

#pragma mark private function...

- (void)nextPage
{
	NSInteger itemCount = [_dataSource numberOfItemsInCycleImageView: self];
	if(0 == itemCount)
	{
		return;
	}
	[_scrollView setContentOffset: CGPointMake(_scrollView.bounds.size.width * 2, 0) animated: YES];
	_currentIndex = (_currentIndex + 1) % itemCount;
}

- (void)previousPage
{
	NSInteger itemCount = [_dataSource numberOfItemsInCycleImageView: self];
	if(0 == itemCount)
	{
		return;
	}
	[_scrollView setContentOffset: CGPointZero animated: YES];
	_currentIndex = (itemCount + _currentIndex - 1) % itemCount;
}

- (void)update
{
	NSInteger itemCount = [_dataSource numberOfItemsInCycleImageView: self];
	NSInteger prevIndex = (itemCount + _currentIndex - 1) % itemCount;
	NSInteger nextIndex = (_currentIndex + 1) % itemCount;
	
	_currentImageView.image = [_dataSource cycleImageView: self imageForItemAtIndex: _currentIndex];
	_prevImageView.image = [_dataSource cycleImageView: self imageForItemAtIndex: prevIndex];
	_nextImageView.image = [_dataSource cycleImageView: self imageForItemAtIndex: nextIndex];
	[_scrollView setContentOffset: CGPointMake(_scrollView.bounds.size.width, 0) animated: NO];
}

- (void)startTimer
{
	[self stopTimer];
	NSTimeInterval timeInterval = 3.0;
	if(_dataSource && [_dataSource respondsToSelector: @selector(timeIntervalForCycleImageView:)])
	{
		timeInterval = [_dataSource timeIntervalForCycleImageView: self];
	}
	self.timer = [NSTimer scheduledTimerWithTimeInterval: timeInterval target: self selector: @selector(nextPage) userInfo: nil repeats: YES];
}

- (void)stopTimer
{
	if(_timer && _timer.valid)
	{
		[_timer invalidate];
		self.timer = nil;
	}
}

- (void)addScrollViewConstraints
{
	if(![self.scrollView.superview isEqual: self])
	{
		return;
	}
	_scrollView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint *constraintTop = [NSLayoutConstraint constraintWithItem: _scrollView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0];
	NSLayoutConstraint *constraintLeft = [NSLayoutConstraint constraintWithItem: _scrollView attribute: NSLayoutAttributeLeft relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeLeft multiplier: 1.0 constant: 0];
	NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem: _scrollView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0];
	NSLayoutConstraint *constraintRight = [NSLayoutConstraint constraintWithItem: _scrollView attribute: NSLayoutAttributeRight relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeRight multiplier: 1.0 constant: 0];
	[self addConstraints: @[constraintTop, constraintLeft, constraintBottom, constraintRight]];
}

#pragma mark scroll view delegate...

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	NSInteger itemCount = [_dataSource numberOfItemsInCycleImageView: self];
	if(0 == scrollView.contentOffset.x)
	{
		_currentIndex = (itemCount + _currentIndex - 1) % itemCount;
	}
	else if(scrollView.bounds.size.width * 2 == scrollView.contentOffset.x)
	{
		_currentIndex = (_currentIndex + 1) % itemCount;
	}
	[self update];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	[self update];
}

#pragma mark lazy load...

- (UIScrollView *)scrollView
{
	if(nil == _scrollView)
	{
		_scrollView = [[UIScrollView alloc] initWithFrame: self.bounds];
		_scrollView.delegate = self;
		_scrollView.pagingEnabled = YES;
		_scrollView.bounces = NO;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.showsHorizontalScrollIndicator = NO;
	}
	return _scrollView;
}

- (UIImageView *)currentImageView
{
	if(nil == _currentImageView)
	{
		_currentImageView = [[UIImageView alloc] init];
	}
	return _currentImageView;
}

- (UIImageView *)prevImageView
{
	if(nil == _prevImageView)
	{
		_prevImageView = [[UIImageView alloc] init];
	}
	return _prevImageView;
}

- (UIImageView *)nextImageView
{
	if(nil == _nextImageView)
	{
		_nextImageView = [[UIImageView alloc] init];
	}
	return _nextImageView;
}

@end

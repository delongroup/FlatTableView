//
// VerticalScrollBar.m
// refernce:http://github.com/litl/WKVerticalScrollBar
//
//  Created by chendailong2014@126.com on 14-4-22.
//  Copyright (c) 2014年 com.derlongroup. All rights reserved.
//

#import "VerticalScrollBar.h"
#import <QuartzCore/QuartzCore.h>

#define CLAMP(x, low, high)  (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))

@interface VerticalScrollBar ()
- (void)commonInit;
@end

@implementation VerticalScrollBar
{
    CALayer *handle;
    CGRect handleHitArea;
    UIColor *normalColor;
    UIColor *selectedColor;
    
    CGFloat _handleCornerRadius;
    CGFloat _handleSelectedCornerRadius;
    CGFloat _handleSelectedWidth;
    CGFloat _handleHitWidth;
    
    UIScrollView *_scrollView;
}

@synthesize handleWidth = _handleWidth;
@synthesize handleMinimumHeight = _handleMinimumHeight;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _handleWidth = 2.5f;
    _handleSelectedWidth = 0.f;
    _handleHitWidth = 0.f;
    _handleMinimumHeight = 70.0f;
    
    _handleCornerRadius = _handleWidth / 2;
    _handleSelectedCornerRadius = _handleSelectedWidth / 2;
    
    handleHitArea = CGRectZero;
    
    normalColor = [[UIColor colorWithWhite:0.6f alpha:0.7f] retain];
    selectedColor = [[UIColor colorWithWhite:0.4f alpha:1.0f] retain];
    
    handle = [[CALayer alloc] init];
    [handle setCornerRadius:_handleCornerRadius];
    [handle setAnchorPoint:CGPointMake(1.0f, 0.0f)];
    [handle setFrame:CGRectMake(0, 0, _handleWidth, 0)];
    [handle setBackgroundColor:[normalColor CGColor]];
    [[self layer] addSublayer:handle];
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setHandleVisible:) object:nil];

    [handle release];
    
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [_scrollView removeObserver:self forKeyPath:@"contentSize"];
    [_scrollView release];
    [normalColor release];
    [selectedColor release];

    [super dealloc];
}

- (UIScrollView *)scrollView
{
    return _scrollView;
}

- (void)setScrollView:(UIScrollView *)scrollView;
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [_scrollView removeObserver:self forKeyPath:@"contentSize"];

    [_scrollView release];
    _scrollView = [scrollView retain];
    
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    
    [self setNeedsLayout];
}

- (CGFloat)handleCornerRadius
{
    return _handleCornerRadius;
}

- (void)setHandleCornerRadius:(CGFloat)handleCornerRadius
{
    _handleCornerRadius = handleCornerRadius;
    [handle setCornerRadius:_handleCornerRadius];
}

- (CGFloat)handleSelectedCornerRadius
{
    return _handleSelectedCornerRadius;
}

- (void)setHandleSelectedCornerRadius:(CGFloat)handleSelectedCornerRadius
{
    _handleSelectedCornerRadius = handleSelectedCornerRadius;
    [handle setCornerRadius:_handleSelectedCornerRadius];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat contentHeight = [_scrollView contentSize].height;
    CGFloat frameHeight = [_scrollView frame].size.height;
    
    if (contentHeight <= frameHeight)
    {
        // Prevent divide by 0 below when we arrive here before _scrollView has geometry.
        // Also explicity hide handle when not needed, occasionally it's left visible due to
        // layoutSubviews being called with transient & invalid geometery
        [handle setOpacity:0.0f];
        return;
    }

    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    CGRect bounds = [self bounds];
    
    // Calculate the current scroll value (0, 1) inclusive.
    // Note that contentOffset.y only goes from (0, contentHeight - frameHeight)
    // prevent divide by 0 below when we arrive here before _scrollView has geometry
    CGFloat scrollValue = (contentHeight - frameHeight == 0) ? 0
                           : [_scrollView contentOffset].y / (contentHeight - frameHeight);
    
    // Set handleHeight proportionally to how much content is being currently viewed
    CGFloat handleHeight = CLAMP((frameHeight / contentHeight) * bounds.size.height,
                                 _handleMinimumHeight, bounds.size.height);
    
    [handle setOpacity:(handleHeight == bounds.size.height) ? 0.0f : 1.0f];
    
    // Not only move the handle, but also shift where the position maps on to the handle,
    // so that the handle doesn't go off screen when the scrollValue approaches 1.
    CGFloat handleY = CLAMP((scrollValue * bounds.size.height) - (scrollValue * handleHeight),
                            0, bounds.size.height - handleHeight);

    CGFloat previousWidth = [handle bounds].size.width ?: _handleWidth;
    [handle setPosition:CGPointMake(bounds.size.width - _handleWidth, handleY)];
    [handle setBounds:CGRectMake(0, 0, previousWidth, handleHeight)];
    
    handleHitArea = CGRectMake(bounds.size.width - _handleHitWidth, handleY,
                               _handleHitWidth, handleHeight);
    
    [CATransaction commit];
}

- (BOOL)handleVisible
{
    return [handle opacity] == 1.0f;
}

- (void)setHandleVisible:(BOOL)handleVisible
{
    handle.opacity = handleVisible ? 1.0f : 0.f;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return CGRectContainsPoint(handleHitArea, point);
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object != _scrollView)
    {
        return;
    }

    [self setNeedsLayout];

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setHandleVisible:) object:nil];
    self.handleVisible = YES;
    [self performSelector:@selector(setHandleVisible:) withObject:nil afterDelay:0.75];
}

@end

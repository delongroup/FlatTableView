//
//  FlatTableViewCell.m
//  FlatTableView
//
//  Created by Delon on 14-5-5.
//  Copyright (c) 2014年 com.derlongroup. All rights reserved.
//

#import "FlatTableViewCell.h"
#import "TableViewStyle.h"

@implementation FlatTableViewCell
{
    UIView *_topBorderView;
    UIView *_bottomBorderView;
}

- (void)setCellBorders:(NSInteger)cellBorders
{
    if ((cellBorders & FlatTableViewCellBorder_top) == FlatTableViewCellBorder_top)
    {
        _topBorderView.hidden = NO;
    } else {
        _topBorderView.hidden = YES;
    }
    
    if ((cellBorders & FlatTableViewCellBorder_bottom) == FlatTableViewCellBorder_bottom)
    {
        _bottomBorderView.hidden = NO;
    } else {
        _bottomBorderView.hidden = YES;
    }
}

- (NSInteger)cellBorders
{
    NSInteger cellBorders = 0;
    
    if (!_topBorderView.hidden)
    {
        cellBorders |= FlatTableViewCellBorder_top;
    }
    
    if (!_bottomBorderView.hidden)
    {
        cellBorders |= FlatTableViewCellBorder_bottom;
    }
    
    return cellBorders;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _topBorderView = [[UIView alloc] initWithFrame:CGRectZero];
        _topBorderView.backgroundColor = kTableViewCellBorderColor;
        [self.contentView addSubview:_topBorderView];
        [_topBorderView release];
        
        _bottomBorderView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomBorderView.backgroundColor = kTableViewCellBorderColor;
        [self.contentView addSubview:_bottomBorderView];
        [_bottomBorderView release];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        backgroundView.backgroundColor = kTableViewCellBackgroundColor;
        self.backgroundView = backgroundView;
        [backgroundView release];
        
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        selectedBackgroundView.backgroundColor = kTableViewCellSelectColor;
        self.selectedBackgroundView = selectedBackgroundView;
        [selectedBackgroundView release];
        
        self.textLabel.backgroundColor = self.detailTextLabel.backgroundColor = kTableViewCellSelectColor;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    self.backgroundView.frame = self.bounds;
    self.selectedBackgroundView.frame = self.bounds;
    
    _topBorderView.frame = CGRectMake(0, 0, self.bounds.size.width, kTableViewCellBorderSize);
    
    if ([UIScreen mainScreen].scale > 1)
    {
        _bottomBorderView.frame = CGRectMake(0, self.bounds.size.height - kTableViewCellBorderSize, self.bounds.size.width, kTableViewCellBorderSize);
    } else {
        _bottomBorderView.frame = CGRectMake(0, self.bounds.size.height - kTableViewCellBorderDoubleSize, self.bounds.size.width, kTableViewCellBorderDoubleSize);
    }

    self.imageView.frame = CGRectMake(kTableViewMargin, self.imageView.frame.origin.y, self.imageView.bounds.size.width, self.imageView.bounds.size.height);
    
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + kTableViewMargin, self.textLabel.frame.origin.y, self.textLabel.bounds.size.width, self.textLabel.bounds.size.height);
    self.detailTextLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + kTableViewMargin, self.detailTextLabel.frame.origin.y, self.detailTextLabel.bounds.size.width, self.detailTextLabel.bounds.size.height);
    
    self.accessoryView.frame = CGRectMake(self.bounds.size.width - self.accessoryView.bounds.size.width - kTableViewMargin, self.accessoryView.frame.origin.y, self.accessoryView.bounds.size.width, self.accessoryView.bounds.size.height);
}
@end

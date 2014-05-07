//
//  GroupTableView.m
//  FlatTableView
//
//  Created by Delon on 14-5-5.
//  Copyright (c) 2014年 com.derlongroup. All rights reserved.
//

#import "GroupTableView.h"
#import "VerticalScrollBar.h"
#import "FlatTableViewSectionHeader.h"
#import "FlatTableViewCell.h"
#import "TableViewStyle.h"

@interface GroupTableView () < UITableViewDataSource, UITableViewDelegate >

@end

@implementation GroupTableView
{
    UITableView *_tableView;
    VerticalScrollBar *_verticalScrollBar;
    UILabel *_groupLabel;
}

- (void)showGroupLabelWith:(NSString *)title
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenGroupLabel) object:nil];
    
    _groupLabel.text = title;
    [_groupLabel sizeToFit];
    _groupLabel.frame = CGRectMake(self.bounds.origin.x + self.bounds.size.width * 0.618f - _groupLabel.bounds.size.width / 2, self.bounds.origin.y + self.bounds.size.height * 0.2f - _groupLabel.bounds.size.height / 2, _groupLabel.bounds.size.width, _groupLabel.bounds.size.height);
    if (!_groupLabel.superview)
    {
        [self addSubview:_groupLabel];
    }
    
    [self performSelector:@selector(hiddenGroupLabel) withObject:nil afterDelay:1.0f];
}

- (void)hiddenGroupLabel
{
    [UIView animateWithDuration:0.2 animations:^{
        _groupLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [_groupLabel removeFromSuperview];
        _groupLabel.alpha = 1;
    }];
}

- (id)itemWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [self.dataSource groupTableViewTitles:self][indexPath.section];
    NSArray *items = [self.dataSource groupTableView:self itemsWithTitle:title];
    return items[indexPath.row];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self->_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self->_verticalScrollBar = [[VerticalScrollBar alloc] initWithFrame:CGRectZero];
        self->_groupLabel = [[UILabel alloc] initWithFrame:CGRectZero];

        [self addSubview:_tableView];
        [_tableView release];
        
        [self addSubview:_verticalScrollBar];
        [_verticalScrollBar release];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.sectionIndexColor = [UIColor clearColor];
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_tableView respondsToSelector:@selector(setSectionIndexBackgroundColor:)])
        {
            _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        }
        _tableView.backgroundColor = kTableViewBackgroundColor;
        
        [_verticalScrollBar setScrollView:_tableView];
        _verticalScrollBar.userInteractionEnabled = NO;
        
        _groupLabel.font = [UIFont boldSystemFontOfSize:KTableViewTitleFontSize];
        _groupLabel.backgroundColor = [UIColor clearColor];
        _groupLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenGroupLabel) object:nil];
    [_groupLabel release];
    
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _tableView.frame = self.bounds;
    _verticalScrollBar.frame = self.bounds;
}

- (void)reloadData
{
    [_tableView reloadData];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.dataSource groupTableViewTitles:self];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (_tableView.contentSize.height > _tableView.bounds.size.height * 2)
    {
        [self showGroupLabelWith:title];
    }
    
    return index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource groupTableViewTitles:self].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.dataSource groupTableViewTitles:self][section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FlatTableViewSectionHeader *flatTableViewSectionHeader = [[[FlatTableViewSectionHeader alloc] initWithFrame:CGRectZero] autorelease];
    NSString *title = [self.dataSource groupTableViewTitles:self][section];
    flatTableViewSectionHeader.headerText = title;
    
    return flatTableViewSectionHeader;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hiddenGroupLabel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableViewHeaderSize;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *title = [self.dataSource groupTableViewTitles:self][section];
    return [self.dataSource groupTableView:self itemsWithTitle:title].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    
    FlatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[FlatTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    cell.cellBorders = FlatTableViewCellBorder_bottom;
    if (indexPath.row == 0)
    {
        cell.cellBorders |= FlatTableViewCellBorder_top;
    }
    
    id item = [self itemWithIndexPath:indexPath];
    [self.delegate groupTableView:self updateCell:cell withItem:item];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(groupTableView:didSelectItem:)])
    {
        id item = [self itemWithIndexPath:indexPath];
        [self.delegate groupTableView:self didSelectItem:item];
    }
}

@end

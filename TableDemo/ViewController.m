//
//  ViewController.m
//  TableDemo
//
//  Created by chendailong2014@126.com on 14-4-22.
//  Copyright (c) 2014年 com.derlongroup. All rights reserved.
//

#import "ViewController.h"

#define kTableViewCellBorderColor [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.00f]


@interface CustomTableViewCell : UITableViewCell
@property(nonatomic,readonly) UIView *topView;
@property(nonatomic,readonly) UIView *bottomView;
@property(nonatomic,readonly) UILabel *leftLabel;
@property(nonatomic,readonly) UILabel *rightLabel;
@end

@implementation CustomTableViewCell
{
    UILabel *_rightLabel;
    UILabel *_leftLabel;
    UIView *_topView;
    UIView *_bottomView;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_leftLabel];
        _leftLabel.backgroundColor = [UIColor clearColor];
        
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_rightLabel];
        _rightLabel.backgroundColor = [UIColor clearColor];
        
        _topView = [[UIView alloc] initWithFrame:CGRectZero];
        _topView.backgroundColor = kTableViewCellBorderColor;
        [self.contentView addSubview:_topView];
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = kTableViewCellBorderColor;
        [self.contentView addSubview:_bottomView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    
    [_rightLabel sizeToFit];
    _rightLabel.frame = CGRectMake(self.bounds.size.width - _rightLabel.bounds.size.width, 0, _rightLabel.bounds.size.width, self.bounds.size.height);
    _topView.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
    _bottomView.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5);
    self.backgroundView.frame = self.bounds;
    self.selectedBackgroundView.frame = self.bounds;
    
    [_leftLabel sizeToFit];
    _leftLabel.frame = CGRectMake(10, 0, self.bounds.size.width, self.bounds.size.height);
}
@end
@interface ViewController () < UITableViewDataSource, UITableViewDelegate >

@end

@implementation ViewController
{
    NSMutableArray *_items;
    NSMutableArray *_indexTitles;
    NSMutableDictionary *_indexGroups;
    UILabel *_label;
    NSTimer *_timer;
    NSDate *_date;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexTitles;
}

- (void)showTitle:(NSString *)title
{
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hiddenTitle) userInfo:nil repeats:YES];
    _date = [NSDate date];
    
    _label.text = title;
    _label.font = [UIFont boldSystemFontOfSize:36];
    [_label sizeToFit];
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.frame = CGRectMake(self.view.bounds.origin.x + (self.view.bounds.size.width - _label.bounds.size.width) / 2, self.view.bounds.origin.y + (self.view.bounds.size.height - _label.bounds.size.height) / 2, _label.bounds.size.width, _label.bounds.size.height);
    if (!_label.superview)
    {
        [self.view addSubview:_label];
    }
}

- (void)hiddenTitle
{
    NSTimeInterval time = [_date timeIntervalSinceNow];
    if (time < -1)
    {
        [UIView animateWithDuration:0.2 animations:^{
            _label.alpha = 0;
        } completion:^(BOOL finished) {
            [_label removeFromSuperview];
            _label.alpha = 1;
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer invalidate];
    _timer = nil;

    [UIView animateWithDuration:0.2 animations:^{
        _label.alpha = 0;
    } completion:^(BOOL finished) {
        [_label removeFromSuperview];
        _label.alpha = 1;
    }];
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //NSLog(@"%d",index);
    [self showTitle:_indexTitles[index]];
    return index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _indexTitles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _indexTitles[section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = [@"   " stringByAppendingString:_indexTitles[section]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:109/255. green:109/255. blue:114/255. alpha:1];
    return label;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self hiddenTitle];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *title = _indexTitles[section];
    NSArray *group = _indexGroups[title];
    return group.count;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([self.tableView respondsToSelector:@selector(setSectionIndexBackgroundColor:)])
    {
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255. green:239/255. blue:244/255. alpha:1];

    self->_items = [[NSMutableArray alloc] initWithCapacity:1024];
    for (NSInteger index = 0; index < 200; index++)
    {
        [_items addObject:[NSString stringWithFormat:@"%c%c%c",'A' + rand()%26,'a' + rand()%26,'a' + rand()%26,nil]];
    }

    self->_indexGroups = [[NSMutableDictionary alloc] initWithCapacity:_indexTitles.count];
    
    for (NSString *item in _items)
    {
        NSString *title = [item substringToIndex:1];
        NSMutableArray *group = _indexGroups[title];
        if (group)
        {
            [group addObject:item];
        } else {
            _indexGroups[title] = [NSMutableArray arrayWithObject:item];
        }
    }
    
    self->_indexTitles = [NSMutableArray arrayWithArray:_indexGroups.allKeys];
    [_indexTitles sortUsingSelector:@selector(compare:)];
    self->_label = [[UILabel alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:217/255. green:217/255. blue:217/255. alpha:1];
       // cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    if (indexPath.row == 0)
    {
        cell.topView.hidden = NO;
    } else {
        cell.topView.hidden = YES;
    }
    
    
    NSString *title = _indexTitles[indexPath.section];
    NSArray *gorup = _indexGroups[title];
    cell.leftLabel.text = gorup[indexPath.row];
    cell.rightLabel.text = [NSString stringWithFormat:@"%d",indexPath.row,nil];
    return cell;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

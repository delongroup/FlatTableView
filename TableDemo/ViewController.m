//
//  ViewController.m
//  TableDemo
//
//  Created by chendailong2014@126.com on 14-4-22.
//  Copyright (c) 2014年 com.derlongroup. All rights reserved.
//

#import "ViewController.h"
#import "GroupTableView.h"
#import "FlatTableViewCell.h"

@interface ViewController () < GroupTableViewDataSource, GroupTableViewDelegate >

@end

@implementation ViewController
{
    NSMutableArray *_items;
    NSMutableArray *_indexTitles;
    NSMutableDictionary *_indexGroups;
    GroupTableView *_groupTableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self->_items = [[NSMutableArray alloc] initWithCapacity:1024];
    for (NSInteger index = 0; index < 100; index++)
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
    
    self->_indexTitles = [[NSMutableArray arrayWithArray:_indexGroups.allKeys] retain];
    [_indexTitles sortUsingSelector:@selector(compare:)];
    
    self->_groupTableView = [[GroupTableView alloc] initWithFrame:self.view.bounds];
    _groupTableView.delegate = self;
    _groupTableView.dataSource = self;
    [self.view addSubview:_groupTableView];
    [_groupTableView release];
    
    [_groupTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSArray *)groupTableViewTitles:(GroupTableView *)tableView
{
    return @[@"Apple",@"Orange",@"Foods"];
}

- (NSArray *)groupTableView:(GroupTableView *)tableView itemsWithTitle:(NSString *)title
{
    return @[@"Features", @"Design Built-in",@"Apps App Store", @"Videos Tech Spec"];
}

- (void)groupTableView:(GroupTableView *)tableView updateCell:(UITableViewCell *)cell withItem:(id)item
{
    cell.textLabel.text = item;
}

- (void)groupTableView:(GroupTableView *)tableView didSelectItem:(id)item
{
    
}

@end


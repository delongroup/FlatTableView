//
//  GroupTableView.h
//  FlatTableView
//
//  Created by Delon on 14-5-5.
//  Copyright (c) 2014年 com.derlongroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupTableView : UIView
@property(nonatomic,assign) id dataSource;
@property(nonatomic,assign) id delegate;

- (void)reloadData;

@end

@protocol GroupTableViewDataSource
@required
- (NSArray *)groupTableViewTitles:(GroupTableView *)tableView;
- (NSArray *)groupTableView:(GroupTableView *)tableView itemsWithTitle:(NSString *)title;
- (void)groupTableView:(GroupTableView *)tableView updateCell:(UITableViewCell *)cell withItem:(id)item;
@end

@protocol GroupTableViewDelegate
@optional
- (void)groupTableView:(GroupTableView *)tableView didSelectItem:(id)item;
@end



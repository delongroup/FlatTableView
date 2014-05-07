//
//  FlatTableViewCell.h
//  FlatTableView
//
//  Created by Delon on 14-5-5.
//  Copyright (c) 2014年 com.derlongroup. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, FlatTableViewCellBorder)
{
    FlatTableViewCellBorder_none = 0,
    FlatTableViewCellBorder_top = 1,
    FlatTableViewCellBorder_bottom = 1 << 1
};

@interface FlatTableViewCell : UITableViewCell
@property(nonatomic,assign) NSInteger cellBorders;
@end

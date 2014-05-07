//
//  FlatTableViewSectionHeader.m
//  FlatTableView
//
//  Created by Delon on 14-5-5.
//  Copyright (c) 2014年 com.derlongroup. All rights reserved.
//

#import "FlatTableViewSectionHeader.h"
#import "TableViewStyle.h"

@implementation FlatTableViewSectionHeader
{
    UILabel *_textLabel;
}

- (void)setHeaderText:(NSString *)headerText
{
    _textLabel.text = headerText;
    [self setNeedsLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self->_textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = kTableViewCellHeaderTextColor;
        [self addSubview:_textLabel];
        [_textLabel release];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [_textLabel sizeToFit];
    _textLabel.frame = CGRectMake(10, self.bounds.size.height - _textLabel.bounds.size.height - kTableViewMargin, _textLabel.bounds.size.width, _textLabel.bounds.size.height);
    
    [super layoutSubviews];
}



@end

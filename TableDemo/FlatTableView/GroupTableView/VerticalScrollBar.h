//
// VerticalScrollBar.h
// refernce:http://github.com/litl/WKVerticalScrollBar
//
//  Created by chendailong2014@126.com on 14-4-22.
//  Copyright (c) 2014年 com.derlongroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerticalScrollBar : UIControl
@property (nonatomic, readwrite) CGFloat handleWidth;
@property (nonatomic, readwrite) CGFloat handleMinimumHeight;
@property (nonatomic, readwrite) BOOL handleVisible;
@property (nonatomic, readwrite, retain) UIScrollView *scrollView;
@end

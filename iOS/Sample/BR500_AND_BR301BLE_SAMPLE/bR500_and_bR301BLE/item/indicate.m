//
//  indicate.m
//  bR500Sample
//
//  Created by ftsafe on 16/1/21.
//  Copyright (C)2016-2020 Feitian Technologies Co. ,Ltd. All rights reserved.
//

#import "indicate.h"
@implementation indicate
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [self addIndicateView];
    }
    return self;
}

-(void)addIndicateView
{
    UIActivityIndicatorView *v  = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [v setCenter:CGPointMake(self.center.x, self.center.y)];
    [v setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self  addSubview:v];
    [v startAnimating];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

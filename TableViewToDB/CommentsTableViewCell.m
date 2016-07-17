//
//  CommentsTableViewCell.m
//  TableViewToDB
//
//  Created by Mitchell Hooper on 7/4/15.
//  Copyright (c) 2015 Chilton Studios. All rights reserved.
//

#import "CommentsTableViewCell.h"

@implementation CommentsTableViewCell
 
- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated
{
    [super setSelected: selected
              animated: animated];

    // Configure the view for the selected state
}

#define RADIUS 10

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    CGFloat top = frame.origin.y;
    CGFloat bottom = top + frame.size.height;
    UIRectCorner corners = UIRectCornerAllCorners;
    CAShapeLayer *mask = [CAShapeLayer layer];
    
    //  superview here is the UITableView
    for (UIView *view in self.superview.subviews)
    {
        if (view.frame.origin.y + view.frame.size.height == top)
        {
            corners = corners & ~(UIRectCornerTopLeft|UIRectCornerTopRight);
        }
        else if (view.frame.origin.y == bottom)
        {
            corners = corners & ~(UIRectCornerBottomLeft|UIRectCornerBottomRight);
        }
    }
    
    mask.path = [UIBezierPath bezierPathWithRoundedRect:
                 CGRectMake(0, 0, frame.size.width, frame.size.height)
                                      byRoundingCorners: corners
                                            cornerRadii: CGSizeMake(RADIUS, RADIUS)].CGPath;
    
    self.layer.mask = mask;
    self.layer.masksToBounds = YES;
}

@end

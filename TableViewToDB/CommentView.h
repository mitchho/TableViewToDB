//
//  CommentView.h
//  TableViewToDB
//
//  Created by Mitchell Hooper on 4/1/16.
//  Copyright © 2016 Chilton Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomColors.h"
#import "ToolbarBackground.h"
#import "SteadyInt.h"

@interface CommentView : UIView

@property (nonatomic, strong) SteadyInt *commentsTableViewRowTapped;
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) UITableView *commentsTableView;

@end

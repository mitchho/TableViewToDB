//
//  ViewController.h
//  TableViewToDB
//
//  Created by Mitchell Hooper on 5/20/15.
//  Copyright (c) 2015 Chilton Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomColors.h"
#import "SteadyInt.h"
//#import "HomeModel.h"
//#import "HomeModel2.h"
#import "Comment.h"
#import "CommentsData.h"
#import "CommentView.h"
#import "CommentsTableViewCell.h"
#import "TableCellBackground.h"

@interface ViewController : UIViewController <CommentsDataDelegate, UITableViewDataSource, UITableViewDelegate>
 
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
//@property (nonatomic, weak) IBOutlet CommentsTableViewCell *headerCell;

@end


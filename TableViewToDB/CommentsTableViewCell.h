//
//  CommentsTableViewCell.h
//  TableViewToDB
//
//  Created by Mitchell Hooper on 7/4/15.
//  Copyright (c) 2015 Chilton Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *commentsIdLabel;
@property (nonatomic, weak) IBOutlet UILabel *commentsDateLabel;

@end

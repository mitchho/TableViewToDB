//
//  CommentsData.h
//  TableViewToDB
//
//  Created by Mitchell Hooper on 5/28/15.
//  Copyright (c) 2015 Chilton Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Comment.h"

@protocol CommentsDataDelegate <NSObject>

-(void) commentsDownloaded: (NSArray *)comments;

@end

@interface CommentsData : NSObject 

@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) UITableView *commentsTableView;
@property (nonatomic, weak) id<CommentsDataDelegate> delegate;

-(void) downloadComments;

@end

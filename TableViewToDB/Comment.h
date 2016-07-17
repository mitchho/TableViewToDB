//
//  Comment.h
//  TableViewToDB
//
//  Created by Mitchell Hooper on 5/20/15.
//  Copyright (c) 2015 Chilton Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *date;

@end

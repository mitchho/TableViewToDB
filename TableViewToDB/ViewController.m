//
//  ViewController.m
//  TableViewToDB
//
//  Created by Mitchell Hooper on 5/20/15.
//  Copyright (c) 2015 Chilton Studios. All rights reserved.
//

#import "ViewController.h"

//  note: the mainScreen properties adjust when the device rotates
#define   DEVICE_WIDTH     [[UIScreen mainScreen] bounds].size.width
#define   DEVICE_HEIGHT    [[UIScreen mainScreen] bounds].size.height

#define   COMMENT_VIEW_WIDTH     420.0
#define   COMMENT_VIEW_HEIGHT    420.0

@interface ViewController ()
{
    
    CustomColors *customColors;
    SteadyInt *commentsTableViewRowTapped;
    CommentsData *commentsData;
    NSArray *feedItems;
    NSMutableArray *comments;
    UIRefreshControl *refreshControl;

}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    customColors = [[CustomColors alloc] init];
    
    self.view.backgroundColor = customColors.casinoGreen;
    
    feedItems = [[NSArray alloc] init];
      
    [self setupCommentsTableView];
    [self setupRefreshControl];
    
    commentsTableViewRowTapped = [[SteadyInt alloc] init];
    commentsData = [[CommentsData alloc] init];
    comments = [[NSMutableArray alloc] init];
    commentsData.delegate = self;
    commentsData.comments = comments;
    commentsData.commentsTableView = self.commentsTableView;
    
    [commentsData downloadComments];
  //  [self.commentsTableView reloadData];
}

#pragma mark - viewDidLoad methods

-(void) setupCommentsTableView
{
    //  without this there is padding above the
    //  section 0 headerView
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //  this is a storyboard object so we don't have
    //  to add it as a subview or call alloc/init.
    self.commentsTableView.backgroundColor = customColors.peaGreen;
    self.commentsTableView.separatorColor = customColors.mustardBrown;
    
    //    Don't add this here: it is already connected in
    //    storyboard and the cell labels will become nil ???
    //    [self.settingsTableView registerClass: [SettingsTableCell class]
    //                   forCellReuseIdentifier: @"SettingsCell"];
    
    self.commentsTableView.dataSource = self;
    self.commentsTableView.delegate = self;
    
    self.commentsTableView.frame = CGRectMake(self.view.bounds.size.width * 0.09, 91.0, self.view.bounds.size.width * 0.82, DEVICE_HEIGHT - 200.0); //+ self.navigationController.navigationBar.frame.size.height));
     
    self.commentsTableView.layer.cornerRadius = 9.0;
    //   self.settingsTableView.sectionFooterHeight = 0.0;
    self.commentsTableView.contentSize = CGSizeMake(self.view.bounds.size.width * 0.82, 1200.0);  //  1300
    
}

-(void) setupRefreshControl
{
    refreshControl = [[UIRefreshControl alloc] init];
     
    [refreshControl addTarget: self
                       action: @selector(refresh:)
             forControlEvents: UIControlEventValueChanged];  //  EventValueChanged
    
  //  self.refreshControl = refreshControl;
    [self.commentsTableView addSubview: refreshControl];
    self.commentsTableView.alwaysBounceVertical = YES;
}

-(void) showCommentView: (NSUInteger) index
{
    self.commentsTableView.userInteractionEnabled = NO;
    
    Comment *comment = [feedItems objectAtIndex: index];
    CommentView *commentView;
    
    if (commentView == nil)
        commentView = [[CommentView alloc] initWithFrame: CGRectMake((DEVICE_WIDTH - COMMENT_VIEW_WIDTH) / 2, 180.0, COMMENT_VIEW_WIDTH, COMMENT_VIEW_HEIGHT)];
    
    commentView.commentsTableViewRowTapped = commentsTableViewRowTapped;
    commentView.comments = comments;
    commentView.commentId = comment.commentId;
    commentView.nameLabel.text = [[NSString alloc] initWithFormat: @"Name: %@", comment.name];
    commentView.emailLabel.text = [[NSString alloc] initWithFormat: @"email: %@", comment.email];
    commentView.commentLabel.text = comment.comment;
    commentView.commentsTableView = self.commentsTableView;
    
    [self.view addSubview: commentView];
     
}

#pragma mark CommentsData delegate method

-(void) commentsDownloaded: (NSArray *)commentsArray
{
    //  this delegate method will get called when
    //  items finish downloading
    feedItems = commentsArray;
    [self.commentsTableView reloadData];
}

#pragma mark TableView data source methods

-(NSInteger) tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    NSInteger numberOfRows;
    numberOfRows = feedItems.count;
    
    return numberOfRows;
}

-(UITableViewCell*)tableView: (UITableView *)tableView
       cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSString *cellIdentifer = @"BasicCell";
    CommentsTableViewCell *theCell = [tableView dequeueReusableCellWithIdentifier: cellIdentifer];
    
    if (theCell.backgroundView == nil)
    {
        theCell.backgroundColor = [UIColor clearColor];
        
        TableCellBackground *commentsTableViewCellBackground =
        [[TableCellBackground alloc] initWithFrame: CGRectMake(0.0, 0.0, 30.0, 44.0)];
        commentsTableViewCellBackground.image = [commentsTableViewCellBackground generateCellBackgroundImage];
        commentsTableViewCellBackground.contentMode = UIViewContentModeScaleToFill;
        
        theCell.backgroundView = commentsTableViewCellBackground;
        //            cell.backgroundView.alpha = 0.51;
    }
     
    if (feedItems.count > 0)
    {
        Comment *comment = [feedItems objectAtIndex: indexPath.row];
       
        theCell.commentsIdLabel.text = comment.commentId;
        theCell.commentsDateLabel.text = comment.date;
        
    //    NSLog(@"commentId: %@", comment.commentId);
    //    NSLog(@"date: %@", comment.date);
    }
   
    NSLayoutConstraint *idLabelXConstraint = [NSLayoutConstraint
                                                constraintWithItem: theCell.commentsIdLabel
                                                attribute: NSLayoutAttributeCenterX
                                                relatedBy: NSLayoutRelationEqual
                                                toItem: theCell
                                                attribute: NSLayoutAttributeRight
                                                multiplier: 0.18
                                                constant: 0.0];
    
    NSLayoutConstraint *idLabelYConstraint = [NSLayoutConstraint
                                                constraintWithItem: theCell.commentsIdLabel
                                                attribute: NSLayoutAttributeCenterY
                                                relatedBy: NSLayoutRelationEqual
                                                toItem: theCell
                                                attribute: NSLayoutAttributeCenterY
                                                multiplier: 1.0
                                                constant: 0.0];
    
    theCell.commentsIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [theCell addConstraint: idLabelXConstraint];
    [theCell addConstraint: idLabelYConstraint];
    
    NSLayoutConstraint *dateLabelXConstraint = [NSLayoutConstraint
                                                 constraintWithItem: theCell.commentsDateLabel
                                                 attribute: NSLayoutAttributeCenterX
                                                 relatedBy: NSLayoutRelationEqual
                                                 toItem: theCell
                                                 attribute: NSLayoutAttributeRight
                                                 multiplier: 0.69
                                                 constant: 0.0];
    
    NSLayoutConstraint *dateLabelYConstraint = [NSLayoutConstraint
                                                 constraintWithItem: theCell.commentsDateLabel
                                                 attribute: NSLayoutAttributeCenterY
                                                 relatedBy: NSLayoutRelationEqual
                                                 toItem: theCell
                                                 attribute: NSLayoutAttributeCenterY
                                                 multiplier: 1.0
                                                 constant: 0.0];
    
    theCell.commentsDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [theCell addConstraint: dateLabelXConstraint];
    [theCell addConstraint: dateLabelYConstraint];
  
    return theCell;
}

/*
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. Dequeue the custom header cell
    self.headerCell = [tableView dequeueReusableCellWithIdentifier: @"HeaderCell"];
    
    // 2. Set the various properties
    self.headerCell.name.text = @"Name";
    [self.headerCell.name sizeToFit];
    
    self.headerCell.latitude.text = @"Latitude";
    [self.headerCell.latitude sizeToFit];
    
//    headerCell.image.image = [UIImage imageNamed:@"smiley-face"];
    
    // 3. And return
    return self.headerCell;
}
*/

#pragma mark - TableView delegate methods

-(void)       tableView: (UITableView *)tableView
didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
//    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    commentsTableViewRowTapped.theInt = (int)row;
    [self showCommentView: row];
}

#pragma mark - TableView refresh control methods

//  note: if you don't pull the tableView down
//  far enough it won't refresh - keep pulling
//  down until you see the control start spinning
- (void)refresh: (UIRefreshControl *)refresher
{
    NSLog(@"in refresh:");
    refresher.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    // do your refresh here and reload the tableview
    [commentsData downloadComments];
    [refresher endRefreshing];
    [self.commentsTableView reloadData];
    
}

@end

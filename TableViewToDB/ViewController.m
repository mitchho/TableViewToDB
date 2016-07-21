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
    NSMutableArray *commentsArray;
//    NSMutableArray *comments;
    UIRefreshControl *refreshControl;

}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    customColors = [[CustomColors alloc] init];
    
    self.view.backgroundColor = customColors.casinoGreen;
    
    commentsArray = [[NSMutableArray alloc] init];
      
    [self setupCommentsTableView];
    [self setupCommentsDataObject];
    [self setupRefreshControl];
    
    commentsTableViewRowTapped = [[SteadyInt alloc] init];
    
    [commentsData downloadComments];
  
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

-(void) setupCommentsDataObject
{
 
    commentsData = [[CommentsData alloc] init];
    commentsData.delegate = self;
    commentsData.commentsArray = commentsArray;
    commentsData.commentsTableView = self.commentsTableView;
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
    
    Comment *comment = [commentsArray objectAtIndex: index];
    CommentView *commentView;
    
    if (commentView == nil)
        commentView = [[CommentView alloc] initWithFrame: CGRectMake((DEVICE_WIDTH - COMMENT_VIEW_WIDTH) / 2, 180.0, COMMENT_VIEW_WIDTH, COMMENT_VIEW_HEIGHT)];
    
    commentView.commentsTableViewRowTapped = commentsTableViewRowTapped;
    commentView.commentsArray = commentsArray;
    commentView.commentId = comment.commentId;
    commentView.nameLabel.text = [[NSString alloc] initWithFormat: @"Name: %@", comment.name];
    commentView.emailLabel.text = [[NSString alloc] initWithFormat: @"email: %@", comment.email];
    commentView.commentLabel.text = comment.comment;
    commentView.commentsTableView = self.commentsTableView;
    
    [self.view addSubview: commentView];
     
}

#pragma mark CommentsData delegate method

-(void) commentsDownloaded: (NSMutableArray *)commentsArrayFromJSON
{
    //  this delegate method will get called when
    //  items finish downloading
    commentsArray = commentsArrayFromJSON;
    
    //  note: don't reload the table here - it gets
    //  reloaded in CommentsData
    //  [self.commentsTableView reloadData];
}

#pragma mark TableView data source methods

-(NSInteger) tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    NSInteger numberOfRows;
    numberOfRows = commentsArray.count;
    
    return numberOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
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
     
    if (commentsArray.count > 0)
    {
        Comment *comment = [commentsArray objectAtIndex: indexPath.row];
       
        theCell.commentsIdLabel.text = comment.commentId;
        theCell.commentsDateLabel.text = comment.date;
        
    //    NSLog(@"commentId: %@", comment.commentId);
    //    NSLog(@"date: %@", comment.date);
    }
    
    /*
    NSLayoutConstraint *idLabelXConstraint = [NSLayoutConstraint
                                                constraintWithItem: theCell.commentsIdLabel
                                                attribute: NSLayoutAttributeLeft
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
                                                 attribute: NSLayoutAttributeLeft
                                                 relatedBy: NSLayoutRelationEqual
                                                 toItem: theCell
                                                 attribute: NSLayoutAttributeRight
                                                 multiplier: 0.60
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
  */
    
    return theCell;
}


-(UIView*)   tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    
    HeaderTableViewCell *headerCell;
    UILabel *headerCellLabel;
    
    if (headerCell == nil)
        headerCell = [[HeaderTableViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, self.commentsTableView.frame.size.width, 39.0)];
    
    headerCell.backgroundColor = [UIColor colorWithRed: (130.0f/255.0f)
                                                 green: (203.0f/255.0f)
                                                  blue: (96.0f/255.0f)
                                                 alpha: 1.0];
    
    if (headerCellLabel == nil)
    {
        headerCellLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.commentsTableView.bounds.size.width * 0.2, 10.0, self.commentsTableView.bounds.size.width * 0.60, 24.0)];
    //    headerCellLabel.center = headerCell.center;
        headerCellLabel.textAlignment = NSTextAlignmentCenter;
        headerCellLabel.textColor = [UIColor colorWithRed: 1.0
                                                    green: 1.0
                                                     blue: 1.0
                                                    alpha: 0.75];
        
        headerCellLabel.backgroundColor = [UIColor clearColor];
        headerCellLabel.text = @"www.chiltonstudios.com User Comments";
        
        [headerCell addSubview: headerCellLabel];
    }
    
    return headerCell;
  
}

-(CGFloat) tableView: (UITableView *)tableView
heightForHeaderInSection: (NSInteger)section
{
    
    CGFloat headerCellHeight = 39.0;
    
    return headerCellHeight;
}

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
    refresher.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing Comments..."];
    // do your refresh here and reload the tableview
    [commentsData downloadComments];
    [refresher endRefreshing];
    
    //  note: don't reload the table here - it gets
    //  reloaded in CommentsData
    // [self.commentsTableView reloadData];
    
}

@end

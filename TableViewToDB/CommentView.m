//
//  CommentView.m
//  TableViewToDB
//
//  Created by Mitchell Hooper on 4/1/16.
//  Copyright © 2016 Chilton Studios. All rights reserved.
//

#import "CommentView.h"

#define    TOOLBAR_HEIGHT        44.0
#define    NAME_LABEL_HEIGHT     30.0
#define    EMAIL_LABEL_HEIGHT    30.0

@interface CommentView () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) CustomColors *customColors;
 
@end
 
@implementation CommentView

-(id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        self.customColors = [[CustomColors alloc] init];
        self.backgroundColor = self.customColors.customBeige;
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = YES;
         
        [self setupLabels];
        [self setupToolbar];
        
    }
    
    return self;
    
}

-(void) setupToolbar
{
    UIToolbar *commentToolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0.0, 0.0, self.frame.size.width, TOOLBAR_HEIGHT)];
    
    commentToolbar.layer.cornerRadius = 6.0;
    commentToolbar.layer.masksToBounds = YES;
    
    ToolbarBackground *commentToolbarBackground = [[ToolbarBackground alloc] initWithFrame: CGRectMake(0.0, 0.0, self.frame.size.width, TOOLBAR_HEIGHT)];
    
    commentToolbarBackground.image = [[commentToolbarBackground generateToolbarBackgroundImage]
                                       resizableImageWithCapInsets: UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    
    [[UIToolbar appearance] setBackgroundImage: commentToolbarBackground.image
                            forToolbarPosition: UIBarPositionAny
                                    barMetrics: UIBarMetricsDefault];
    
    commentToolbarBackground.contentMode = UIViewContentModeScaleToFill;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                           initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                target: self
                                                action: @selector(doneButtonTapped:)];
    
    doneButton.tintColor = [UIColor blackColor];
    
    UIBarButtonItem *centerSpacer = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                    target: nil
                                    action: nil];
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem: UIBarButtonSystemItemTrash
                                                        target: self
                                                        action: @selector(deleteButtonTapped:)];
    
    deleteButton.tintColor = [UIColor redColor];
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                                                      doneButton,
                                                    centerSpacer,
                                                    deleteButton,
                                                      nil];
    
    [commentToolbar setItems: toolbarItems];
    
    /*
    commentToolbar.leftBarButtonItem = doneButton;
    
    doneButton = [[UIBarButtonItem alloc]
                  initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                  target: self
                  action: @selector(doneButtonTapped)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
    */
    
    [self addSubview: commentToolbar];
    
}

-(void) setupLabels
{
    self.nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(0.0, TOOLBAR_HEIGHT, self.frame.size.width, NAME_LABEL_HEIGHT)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textColor = self.customColors.casinoGreen;
    
    self.emailLabel = [[UILabel alloc] initWithFrame: CGRectMake(0.0, (TOOLBAR_HEIGHT + NAME_LABEL_HEIGHT), self.frame.size.width, EMAIL_LABEL_HEIGHT)];
    self.emailLabel.textAlignment = NSTextAlignmentCenter;
    self.emailLabel.numberOfLines = 0;
    self.emailLabel.textColor = self.customColors.casinoGreen;
    
    self.commentLabel = [[UILabel alloc] initWithFrame: CGRectMake(0.0, (TOOLBAR_HEIGHT + NAME_LABEL_HEIGHT + EMAIL_LABEL_HEIGHT), self.frame.size.width, self.frame.size.height - 80.0)];
    
    self.commentLabel.textAlignment = NSTextAlignmentCenter;
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.backgroundColor = [UIColor whiteColor];
    self.commentLabel.textColor = self.customColors.casinoGreen;
    
    [self addSubview: self.emailLabel];
    [self addSubview: self.nameLabel];
    [self addSubview: self.commentLabel];
}

-(void) doneButtonTapped: (id) sender
{
    [self removeFromSuperview];
    
    self.commentsTableView.userInteractionEnabled = YES;
   
}

-(void) deleteButtonTapped: (id) sender
{
    NSLog(@"commentsTableViewRowTapped.theInt from deleteButtonTapped: %d", self.commentsTableViewRowTapped.theInt);
 //   NSLog(@"comments from deleteButtonTapped: %@", self.comments);
    NSLog(@"# of comments from deleteButtonTapped: %lu", (unsigned long)[self.comments count]);
    
    NSString *hostServer = @"http://localhost:8080/";
 //   NSString *hostServer = @"http://www.chiltonstudios.com/";
    
     //NSString *myUrlString = [NSString stringWithFormat: @"%@PullComments/comments", hostServer];
    NSString *myUrlString = [NSString stringWithFormat: @"%@DeleteComment/delete", hostServer];
    NSURL *myUrl = [NSURL URLWithString: myUrlString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL: myUrl];
    [urlRequest setTimeoutInterval: 60.0f];
    [urlRequest setHTTPMethod: @"POST"];
    //  tell it which table row to delete
    NSData *requestBodyData = [self.commentId dataUsingEncoding: NSUTF8StringEncoding];
    urlRequest.HTTPBody = requestBodyData;
    
    //  create the NSURLConnection and set delegate to self
    //  note: I am pretty sure this connection is done
    //  asynchronously, ie does not block the main thread
    [NSURLConnection connectionWithRequest: urlRequest
                                  delegate: self];
    
    [self.comments removeObjectAtIndex: self.commentsTableViewRowTapped.theInt];
    [self.commentsTableView reloadData];
    
    [self removeFromSuperview];
    
    self.commentsTableView.userInteractionEnabled = YES;
    
}

#pragma mark NSURLConnectionDataDelegate methods

-(void) connection: (NSURLConnection *)connection
didReceiveResponse: (NSURLResponse *)response
{
    //  initialize the data object
   NSLog(@"in didReceiveResponse:");
}

-(void) connection: (NSURLConnection *)connection
    didReceiveData: (NSData *)data
{
    //  append the newly downloaded data
    NSLog(@"in didReceiveData:");
   
}

-(void) connectionDidFinishLoading: (NSURLConnection *)connection
{
   
    NSLog(@"in connectionDidFinishLoading:");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

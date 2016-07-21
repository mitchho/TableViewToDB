//
//  CommentsData.m
//  TableViewToDB
//
//  Created by Mitchell Hooper on 5/28/15.
//  Copyright (c) 2015 Chilton Studios. All rights reserved.
//

#import "CommentsData.h"

@interface CommentsData() <NSURLConnectionDataDelegate>
{
    NSMutableData *downloadedData;
}

@end

@implementation CommentsData

-(void) downloadComments
{
//    NSLog(@"in downloadComments");
//    NSString *hostServer = @"http://localhost:8080/";
    NSString *hostServer = @"http://www.chiltonstudios.com/";
    
//    NSString *myUrlString = [NSString stringWithFormat: @"%@Locations/locations", hostServer];
    NSString *myUrlString = [NSString stringWithFormat: @"%@PullComments/comments", hostServer];
    NSURL *myUrl = [NSURL URLWithString: myUrlString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL: myUrl];
    [urlRequest setTimeoutInterval: 60.0f];
    [urlRequest setHTTPMethod: @"POST"];
    
     //  note: this method happens asynchonously (off main queue)
     //  but NSURLConnection got deprecated in iOS 9 so use
     //  NSURLSession instead.
     //  [NSURLConnection connectionWithRequest: urlRequest
     //                             delegate: self];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest: urlRequest
                                                completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    
                                                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: data
                                                                                                         options: 0
                                                                                                           error: nil];
                                                //    NSLog(@"%@", json);
                                                    
                                                    if ((json != nil) && (error == nil))
                                                    {
                                                        NSLog(@"successfully deserialized");
                                                        [self convertJSONToCommentsArray: json];
                                                    }
                                                }];
    
    [dataTask resume];
}

-(void) convertJSONToCommentsArray: (NSDictionary *)json
{
    //  create an array to store the Comment dictionary objects
    NSMutableArray *commentsArrayOfDicts = [[NSMutableArray alloc] init];
    [self.commentsArray removeAllObjects];
    
    NSNumber *success = [json objectForKey: @"success"];
    
    if ([success boolValue] == YES)
    {
        //  note: commentsArray is an array of dictionaries
        //  the keys are: "comment_id", "name", "email",
        //  "comment", and "date"
        commentsArrayOfDicts = [json objectForKey: @"commentList"];
        NSLog(@"commentsArrayOfDicts: %@", commentsArrayOfDicts);
        
        //  loop thru the json objects, create comment objects
        //  and add them to the comments array
        for (int i = 0; i < commentsArrayOfDicts.count; i++)
        {
            NSDictionary *jsonElement = [commentsArrayOfDicts objectAtIndex: i];
            // NSLog(@"jsonElement: %@", jsonElement);
            
            //  create a new comment object and set its
            //  properties to jsonElement properties
            Comment *newComment = [[Comment alloc] init];
            
            //  newComment.commentId = jsonElement[@"comment_id"];
            //  not sure what the "comment_id" value is as far
            //  as the data type (NSNumber ?) so lets convert
            //  it to a string. The others were strings all along.
            newComment.commentId = [NSString stringWithFormat: @"%@", jsonElement[@"comment_id"]];
            newComment.name = jsonElement[@"name"];
            newComment.email = jsonElement[@"email"];
            newComment.comment = jsonElement[@"comment"];
            newComment.date = jsonElement[@"date"];
            
            //  add this comment to the comments array
            [self.commentsArray addObject: newComment];
            
        }  //  end for loop
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.commentsTableView reloadData];
            
        });

    }  //  end success
    
    //  ready to notify delegate that data is ready and
    //  pass back items
    
    if (self.delegate)
    {
        [self.delegate commentsDownloaded: self.commentsArray];
    }
}

#pragma mark NSURLConnectionDataDelegate methods

-(void) connection: (NSURLConnection *)connection
didReceiveResponse: (NSURLResponse *)response
{
    //  initialize the data object
    downloadedData = [[NSMutableData alloc] init];
}

-(void) connection: (NSURLConnection *)connection
    didReceiveData: (NSData *)data
{
    //  append the newly downloaded data
    [downloadedData appendData: data];
}

-(void) connectionDidFinishLoading: (NSURLConnection *)connection
{
    //  create an array to store the Comment dictionary objects
    NSMutableArray *commentsArrayOfDicts = [[NSMutableArray alloc] init];
    [self.commentsArray removeAllObjects];
    
    NSString *theData = [[NSString alloc] initWithData: downloadedData
                                              encoding: NSUTF8StringEncoding];
    
    NSLog(@"JSON data = %@", theData);
    
    //  parse the json that came in
    NSError *error;
    
    //  note: the only 2 keys in jsonObject should be "success"
    //  and "commentList". They were created in the java servlet.
   id jsonObject = [NSJSONSerialization JSONObjectWithData: downloadedData
                                                   options: NSJSONReadingAllowFragments
                                                     error: &error];
    
    if ((jsonObject != nil) && (error == nil))
    {
        NSLog(@"successfully deserialized");
        
        NSNumber *success = [jsonObject objectForKey: @"success"];
        
        if ([success boolValue] == YES)
        {
            //  note: commentsArray is an array of dictionaries
            //  the keys are: "comment_id", "name", "email",
            //  "comment", and "date"
            commentsArrayOfDicts = [jsonObject objectForKey: @"commentList"];
            NSLog(@"commentsArrayOfDicts: %@", commentsArrayOfDicts);
            
            /*
            NSDictionary *comment = [comments objectAtIndex: 2];
            NSNumber *commentID = [comment objectForKey: @"comment_id"];
            
            NSLog(@"comment dictionary: %@", comment);
            NSLog(@"commentID NSNumber: %@", commentID);
             */
            
            //  loop thru the json objects, create comment objects
            //  and add them to the comments array
            for (int i = 0; i < commentsArrayOfDicts.count; i++)
            {
                NSDictionary *jsonElement = [commentsArrayOfDicts objectAtIndex: i];
               // NSLog(@"jsonElement: %@", jsonElement);
                
                //  create a new comment object and set its
                //  properties to jsonElement properties
                Comment *newComment = [[Comment alloc] init];
                
              //  newComment.commentId = jsonElement[@"comment_id"];
                //  not sure what the "comment_id" value is as far
                //  as the data type (NSNumber ?) so lets convert
                //  it to a string. The others were strings all along.
                newComment.commentId = [NSString stringWithFormat: @"%@", jsonElement[@"comment_id"]];
                newComment.name = jsonElement[@"name"];
                newComment.email = jsonElement[@"email"];
                newComment.comment = jsonElement[@"comment"];
                newComment.date = jsonElement[@"date"];
                
                //  add this comment to the comments array
                [self.commentsArray addObject: newComment];
                
            }  //  end for loop
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                 [self.commentsTableView reloadData];
                
            });
            
        }  //  end success
    }  //  end if ((jsonObject != nil) && (error == nil))
     
    //  ready to notify delegate that data is ready and
    //  pass back items
    
    if (self.delegate)
    {
        [self.delegate commentsDownloaded: self.commentsArray];
    }
    
}

@end

//
//  ConnectViewController.h
//  iGuelph
//
//  Created by Lion User on 07/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectViewController : UITableViewController {
    NSDictionary *items;
    UIActivityIndicatorView *spinner;
    IBOutlet UIBarButtonItem *refreshButton;
}

//@property (strong, nonatomic) NSMutableArray *items;

- (void)fetchNews;

@end

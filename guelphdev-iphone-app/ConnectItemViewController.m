//
//  ConnectItemViewController.m
//  iGuelph
//
//  Created by Lion User on 08/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConnectItemViewController.h"

@interface ConnectItemViewController ()
- (void)configureView;
@end

@implementation ConnectItemViewController

@synthesize item = _item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)setItem:(NSDictionary *)newItem
{
    if (_item != newItem) {
        _item = newItem;
    
        [self configureView];
    }
}

- (void)configureView
{
    NSDictionary *item = self.item;
    if (item) {
        NSString *title = [item objectForKey:@"title"];
        NSString *content = [item objectForKey:@"content"];

        textContent.text = content;
        
        textTitle.lineBreakMode = UILineBreakModeWordWrap;
        textTitle.numberOfLines = 0;
        textTitle.text = title;
        CGSize maximumLabelSize = CGSizeMake(296,9999);
        CGSize expectedLabelSize = [title sizeWithFont:textTitle.font 
                                    constrainedToSize:maximumLabelSize 
                                    lineBreakMode:textTitle.lineBreakMode]; 
        CGRect newFrame = textTitle.frame;
        newFrame.size.height = expectedLabelSize.height;
        textTitle.frame = newFrame;
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {  
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {  
        return YES;  
    } else {  
        return NO;  
    }  
} 

@end

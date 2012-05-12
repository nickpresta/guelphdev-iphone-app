//
//  ConnectItemViewController.h
//  iGuelph
//
//  Created by Lion User on 08/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectItemViewController : UIViewController {
    IBOutlet UITextView *textContent;
    IBOutlet UILabel *textTitle;
}

@property (strong, nonatomic) NSDictionary *item;

@end

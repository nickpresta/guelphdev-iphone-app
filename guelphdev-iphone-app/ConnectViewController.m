//
//  ConnectViewController.m
//  iGuelph
//
//  Created by Lion User on 07/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConnectViewController.h"
#import "ConnectItemViewController.h"

@interface ConnectViewController ()

@end

@implementation ConnectViewController

- (IBAction)refreshView:(id)sender
{
    [self fetchNews];
}

- (void)fetchNews
{
    [spinner startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:
                         @"https://apiguelph-nickpresta.dotcloud.com/api/v1/news/?format=json&username=testuser&api_key=2bec98eb2126dbc3585e1658a8d22534c988daba"]];
        
        NSError *error;
        
        if (data) {
            items = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
            
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];
            [self.tableView reloadData]; 
        });
    });
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    spinner = [[UIActivityIndicatorView alloc] 
               initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.backgroundColor = [UIColor blackColor];
    spinner.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    spinner.center = CGPointMake(self.navigationController.view.center.x,
                                 self.navigationController.view.center.y - 24);
    spinner.alpha = 0.5;
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [self fetchNews];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[items objectForKey:@"objects"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:@"ConnectCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConnectCell"];
    }

    NSDictionary *item = [[items objectForKey:@"objects"] objectAtIndex:indexPath.row];
	cell.textLabel.text = [item objectForKey:@"title"];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    NSString *dateString = [item objectForKey:@"datetime_published"];
    
    NSDate *date = nil;
    NSError *error = nil;
    if (![dateFormatter getObjectValue:&date forString:dateString range:nil error:&error]) {
        NSLog(@"Could not parse '%@': %@", dateString, error);
    }
    
    NSDateFormatter *displayDateFormatter = [[NSDateFormatter alloc] init];
    [displayDateFormatter setDateFormat:@"E LLL dd 'at' HH:mm a"];
	cell.detailTextLabel.text = [@"Posted on " stringByAppendingString:
                                 [displayDateFormatter stringFromDate:date]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [[items objectForKey:@"objects"] objectAtIndex:indexPath.row];

    NSString *cellText = [item objectForKey:@"title"];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    NSString *cellTextDetail = [item objectForKey:@"datetime_published"];
    UIFont *cellDetailFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintDetailSize = CGSizeMake(180.0f, MAXFLOAT);
    CGSize detailedTextSize = [cellTextDetail sizeWithFont:cellDetailFont constrainedToSize:constraintDetailSize lineBreakMode:UILineBreakModeWordWrap];
    
    return (labelSize.height + detailedTextSize.height) + 35;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0, 0, 24, 24);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = spinner;
    [spinner startAnimating];
    */
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showConnectItem"]) {
        
        NSInteger row = [[self tableView].indexPathForSelectedRow row];
        NSDictionary *item = [[items objectForKey:@"objects"] objectAtIndex:row];
        
        ConnectItemViewController *connectItemViewController = segue.destinationViewController;
        connectItemViewController.item = item;
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

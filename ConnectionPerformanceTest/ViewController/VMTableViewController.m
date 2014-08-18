//
//  VMTableViewController.m
//  ConnectionPerformanceTest
//
//  Created by banana on 14-8-6.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import "VMTableViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "VMTableViewCell.h"
#import "VMApplication.h"
#import "VMIcon.h"

@interface VMTableViewController ()

@end

@implementation VMTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
//    [[[[self navigationController] navigationBar] topItem] setTitle:[self title]];
}

- (void)viewDidAppear:(BOOL)animated{
    VMPrintlog("..View Of Launch Items Did Show..");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSArray *array = [_dataSource objectForKey:@"applications"];
    
    return [array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tableCell";
    VMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[VMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    VMApplication *app = [[_dataSource objectForKey:@"applications"] objectAtIndex:[indexPath row]];
    [[cell name] setText:[app name]];
    [[cell version] setText:[app version]];
    [[cell publisher] setText:[app publisher]];
    
    NSString *url = [NSString stringWithFormat:@"https://%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"server_addr"]];
    VMIcon *icon = [[app icons] objectAtIndex:0];
    [[cell icon] setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:[icon path]]]
                   placeholderImage:[UIImage imageNamed:@"Default-icon"]];
    
//    for (VMIcon *icon in [app icons]) {
//        NSString *src = [url stringByAppendingString:[icon path]];
//        NSLog(@"url = %@, %@ * %@",src,[icon width],[icon height]);
//        
//    }
    return cell;
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

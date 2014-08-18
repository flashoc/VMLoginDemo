//
//  VMLogTableViewController.m
//  ConnectionPerformanceTest
//
//  Created by banana on 14-8-13.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import "VMLogTableViewController.h"

@interface VMLogTableViewController ()

@end

@implementation VMLogTableViewController

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
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    return [_directoryContent count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"directoryViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [cell textLabel].text = [_directoryContent objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selected = [_directoryContent objectAtIndex:indexPath.row];
    NSString *selectedPath = [_directoryPath stringByAppendingPathComponent:selected];
    if ([[NSFileManager defaultManager] fileExistsAtPath:selectedPath]) {
        if ([self.delegate respondsToSelector:@selector(showTheLogAtPath:)]) {
            [self.delegate performSelector:@selector(showTheLogAtPath:)
                                withObject:selectedPath];
        }
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

#pragma mark - setter

- (void)setDirectoryPath:(NSString *)directoryPath{
    _directoryPath = directoryPath;
    [self loadDirectoryContent];
}

#pragma mark - user defined

- (void)loadDirectoryContent{
    if (!_directoryContent) {
        _directoryContent = [[NSMutableArray alloc] init];
    }
    NSArray* reversedArray = [[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:_directoryPath
                                                                                   error:nil] reverseObjectEnumerator] allObjects];
    [_directoryContent setArray:reversedArray];
}

- (BOOL)deleteFileOfName:(NSString *)name{
    NSString *path = [_directoryPath stringByAppendingPathComponent:name];
    BOOL canDelete = [[NSFileManager defaultManager] isDeletableFileAtPath:path];
    if (!canDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"The file is in used, can not be deleted"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return NO;
    }
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    return YES;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSInteger row = indexPath.row;
        NSString *fileName = [_directoryContent objectAtIndex:row];
        
        if ([self deleteFileOfName:fileName]) {
            [_directoryContent removeObjectAtIndex:row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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

//
//  VMViewController.m
//  ConnectionPerformanceTest
//
//  Created by banana on 14-7-31.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import "VMViewController.h"
#import "VMWebService.h"
#import "VMXMLParser.h"
#import "VMAppDelegate.h"
#import "VMCheckResponseResult.h"
#import "VMTableViewController.h"
#import "VMLogTableViewController.h"

#define SERVERIP @"10.117.161.67"
#define LOGINTOSERVER @"LOGIN TO SERVER"
#define INPUTSERVERADDR @"INPUT SERVER ADDRESS"

@interface VMViewController ()

@property (nonatomic, strong) VMWebService *svrConnect;

@end

@implementation VMViewController{
    NSString *_srvAddr;
    NSString *_usr;
    NSString *_psw;
    NSDictionary *_launchItems;
    //    BOOL _clear;
    UIActivityIndicatorView* _aiv;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //    _clear = NO;
    [self setSubviewsLayout];
    [[[[self navigationController] navigationBar] topItem] setTitle:@"Performance Test"];
}

- (void)viewDidAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showLogFiles"]) {
        VMLogTableViewController *table = [segue destinationViewController];
        table.delegate = self;
        if ([table respondsToSelector:@selector(setDirectoryPath:)]) {
            [table setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"logDirectory"] forKey:@"directoryPath"];
        }
    }
}

#pragma mark - PropertyFunction

- (VMWebService *)svrConnect{
    if (!_svrConnect) {
        NSString *url = [NSString stringWithFormat:@"https://%@/broker/xml",[[NSUserDefaults standardUserDefaults] objectForKey:@"server_addr"]];
        _svrConnect = [[VMWebService alloc] initWithURL:[NSURL URLWithString:url]];
        [_svrConnect setDelegate:self];
    }
    return _svrConnect;
}

#pragma mark - VMWebServiceDelegate

- (void)WebService:(VMWebService *)webService didFailWithError:(NSError *)error{
    [_aiv stopAnimating];
    [self showAlertWithTitle:@"ERROR" andMessage:[error localizedDescription] andTag:4];
}

- (void)WebService:(VMWebService *)webService didFinishWithDictionary:(NSDictionary *)dic{
    [_aiv stopAnimating];
    if (webService.type == VMDoLogout) {
        [self showAlertWithTitle:@"Logout Success" andMessage:nil andTag:1];
    }
}

- (void)WebService:(VMWebService *)webService didFailWithDictionary:(NSDictionary *)dic{
    [_aiv stopAnimating];
    if (webService.type == VMDoLogout) {
        NSString *errStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"error-message"]];
        [self showAlertWithTitle:@"ERROR" andMessage:errStr andTag:1];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)didPresentAlertView:(UIAlertView *)alertView{
    
    if ([[alertView title] isEqualToString:@"ERROR"]){
        VMPrintlog("Alert View Of ERROR Did Show");
    }
    else if ([[alertView title] isEqualToString:@"Logout Success"]){
        VMPrintlog("Alert View Of Logout Did Show");
    }
}

#pragma mark - VMLogTableViewDelegate

- (void)showTheLogAtPath:(NSString *) filePath{
    [self.logView setText:nil];
    NSString *log = [NSString stringWithFormat:@"Log File : %@ \n\n",[filePath lastPathComponent]];
    
    log = [log stringByAppendingString:[NSString stringWithContentsOfFile:filePath
                                                                 encoding:NSUTF8StringEncoding
                                                                    error:nil]];
    [self.logView setText:log];
}

#pragma mark - User Defined Functions

//根据当前屏幕应用所占的空间布局界面上的控件
- (void)setSubviewsLayout{
    
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect logFrame = [[self logView] frame];
    CGRect btnFrame1 = [[self strBtn] frame];
    CGRect btnFrame2 = [[self desBtn] frame];
    CGRect btnFrame3 = [[self clrBtn] frame];
    CGRect btnFrame4 = [[self logBtn] frame];
    
    CGRect tempFrame = CGRectMake(logFrame.origin.x, appFrame.origin.y + 20, logFrame.size.width, appFrame.size.height - 16 - btnFrame1.size.height - 20);
    [[self logView] setFrame:tempFrame];
    
    tempFrame = CGRectMake(btnFrame1.origin.x, tempFrame.origin.y + tempFrame.size.height + 8, btnFrame1.size.width, btnFrame1.size.height);
    [[self strBtn] setFrame:tempFrame];
    
    tempFrame = CGRectMake(btnFrame2.origin.x, tempFrame.origin.y, btnFrame2.size.width, btnFrame2.size.height);
    [[self desBtn] setFrame:tempFrame];
    
    tempFrame = CGRectMake(btnFrame3.origin.x, tempFrame.origin.y, btnFrame3.size.width, btnFrame3.size.height);
    [[self clrBtn] setFrame:tempFrame];
    
    tempFrame = CGRectMake(btnFrame4.origin.x, tempFrame.origin.y, btnFrame4.size.width, btnFrame4.size.height);
    [[self logBtn] setFrame:tempFrame];
}

//- (void)showDicToScreen:(NSDictionary *)dic withDomain:(NSString *)domain{
//    if (dic) {
//        NSEnumerator *e = [dic keyEnumerator];
//        id key;
//        while (key = [e nextObject]) {
//            [self appendStringToTextView:[NSString stringWithFormat:@"[%@]: %@ = %@",domain,(NSString *)key,(NSString *)[dic objectForKey:key]]];
//        }
//    }
//}

- (void)showWaitingView {
    if (!_aiv) {
        _aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 50, [[UIScreen mainScreen] bounds].size.height/2 - 85,100,100)];
        _aiv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _aiv.color = [UIColor darkGrayColor];
        [self.view addSubview:_aiv];
    }
    [_aiv startAnimating];
}

- (void)showUserInputFieldWithTitle:(NSString *)title andMessage:(NSString *)message{
    UIAlertView *popView = [[UIAlertView alloc] init];
    [popView setTitle:title];
    [popView addButtonWithTitle:@"Cancel"];
    [popView setDelegate:self];
    
    //弹出服务器地址输入框
    if ([title isEqualToString:INPUTSERVERADDR]) {
        [popView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [popView addButtonWithTitle:@"OK"];
        
        UITextField *tf = [popView textFieldAtIndex:0];
        tf.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"server_addr"];
    }
    //弹出登录用户名和密码输入框
    else if ([title isEqualToString:LOGINTOSERVER]){
        [popView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        [popView setMessage:message];
        [popView addButtonWithTitle:@"Login"];
        
        UITextField *usr_tf = [popView textFieldAtIndex:0];
        usr_tf.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        
        UITextField *pwd_tf = [popView textFieldAtIndex:1];
        pwd_tf.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        
    }
    
    if ([popView title]) {
        [popView show];
    }
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString*)message andTag:(NSInteger)tag
{
    NSString *log = [NSString stringWithFormat:@"Alert View Of %@ Will Show",title];
    VMPrintlog([log UTF8String]);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    //    [alertView setTag:tag];
    
    [alertView show];
}

//在TextView中新加一行记录
//- (void)appendStringToTextView:(NSString *)str{
//    static NSInteger order = 1;
//    if (_clear) {
//        order = 1;
//        _clear = NO;
//    }
//    NSString *appendString = [NSString stringWithFormat:@"\n%d. ", order++];
//    NSString *text = [self.logView.text stringByAppendingString:appendString];
//    self.logView.text = [text stringByAppendingString:str];
//}

#pragma mark - IBAction

- (IBAction)startBtnClicked:(id)sender{
    VMPrintlog("..View Of Input Server Address Will Show..");
    [self performSegueWithIdentifier:@"InputSvrAdrr" sender:sender];
}

- (IBAction)newLogBtnClicked:(id)sender{
    static NSInteger count = 0;
    NSString *logFilePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"logFilePath"];
    NSString *tmpStr = [logFilePath stringByDeletingPathExtension];
    tmpStr = [tmpStr stringByAppendingFormat:@"-%d",count++];
    logFilePath = [tmpStr stringByAppendingPathExtension:@"log"];
    
    [self.logView setText:[NSString stringWithFormat:@"New Log file has been created : %@",[logFilePath lastPathComponent]]];
    
    freopen([logFilePath UTF8String], "a+", stdout);
}

- (IBAction)logoutBtnClicked:(id)sender{
    [self performSelector:@selector(showWaitingView)];
    [self.svrConnect logout];
}

- (IBAction)showlogBtnClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"showLogFiles" sender:sender];
}

@end

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
    BOOL _clear;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _clear = NO;
    _launchItems = nil;
    [self setSubviewsLayout];
    [[[[self navigationController] navigationBar] topItem] setTitle:@"Performance Test"];
}

- (VMWebService *)svrConnect{
    if (!_svrConnect) {
        NSString *url = [NSString stringWithFormat:@"https://%@/broker/xml",_srvAddr];
        _svrConnect = [[VMWebService alloc] initWithURL:[NSURL URLWithString:url]];
        [_svrConnect setDelegate:self];
    }
    return _svrConnect;
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
    VMTableViewController *table = [segue destinationViewController];
    if ([table respondsToSelector:@selector(setDataSource:)]) {
        [table setValue:_launchItems forKey:@"dataSource"];
    }
}

#pragma mark - VMWebServiceDelegate

- (void)WebService:(VMWebService *)webService didFinishWithXMLData:(NSData *)xmlData{
    NSDictionary *res = nil;
    
    switch (webService.type) {
        case VMSetLocaleRequest:
            VMPrintlog("Response of [SetLocale] received");
            res = [VMXMLParser responseOfSetLocale:xmlData];
            VMPrintlog("XML of [SetLocale] Parsed");
            [self showDicToScreen:res withDomain:@"SetLocale"];
            
            if ([VMCheckResponseResult checkResponseOfSetLocale:res] == VMResponseOK){
                VMPrintlog("response of [SetLocale] is OK");
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:_srvAddr forKey:@"server_addr"];
                [self.svrConnect getConfiguration];
            }
            else{
                VMPrintlog("Error occur in response of [SetLocale]");
                [self showAlertWithTitle:@"ERROR" andMessage:@"SetLcale Error" andTag:1];}
            break;
            
        case VMGetConfigurationRequest:
            VMPrintlog("Response of [GetConfiguration] received");
            res = [VMXMLParser responseOfGetConfiguration:xmlData];
            VMPrintlog("XML of [GetConfiguration] Parsed");
            [self showDicToScreen:res withDomain:@"GetConfiguration"];
            
            if ([VMCheckResponseResult checkResponseOfGetConfiguration:res] == VMAuthenticationWindowsPassword) {
                VMPrintlog("response of [GetConfiguration] is WindowsPassword");
                VMPrintlog("Alert View Of LOGIN TO SERVER Will Show");
                [self showUserInputFieldWithTitle:LOGINTOSERVER andMessage:[[NSUserDefaults standardUserDefaults] objectForKey:@"server_addr"]];
            }
            else{
                VMPrintlog("Error occur in response of [GetConfiguration]");
                [self showAlertWithTitle:@"ERROR" andMessage:[res objectForKey:@"error-message"] andTag:2];
            }
            break;
            
        case VMDoSubmitAuthentication:
            VMPrintlog("Response of [DoSubmitAuthentication] received");
            res = [VMXMLParser responseOfAuthentication:xmlData];
            VMPrintlog("XML of [DoSubmitAuthentication] Parsed");
            [self showDicToScreen:res withDomain:@"SubmitAuthentication"];
            
            if ([VMCheckResponseResult checkResponseOfAuthentication:res] == VMAuthenticationSuccess) {
                VMPrintlog("response of [DoSubmitAuthentication] is success");
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:_usr forKey:@"user"];
                [userDefaults setObject:_psw forKey:@"password"];
                [self.svrConnect getTunnelConnection];
            }
            else if([VMCheckResponseResult checkResponseOfAuthentication:res] == VMAuthenticationErrorPassword){
                VMPrintlog("Error Password in response of [DoSubmitAuthentication]");
                [self showAlertWithTitle:@"ERROR" andMessage:[res objectForKey:@"error"] andTag:3];
            }
            else if([VMCheckResponseResult checkResponseOfAuthentication:res] == VMAuthenticationError){
                VMPrintlog("Error occur in response of [DoSubmitAuthentication]");
                NSString *errStr = [NSString stringWithFormat:@"%@ %@",[res objectForKey:@"error-message"],[res objectForKey:@"user-message"]];
                [self showAlertWithTitle:@"ERROR" andMessage:errStr andTag:3];
            }
            break;
            
        case VMGetTunnelConnection:
            VMPrintlog("Response of [GetTunnelConnection] received");
            res = [VMXMLParser responseOfGetTunnelConnection:xmlData];
            VMPrintlog("XML of [GetTunnelConnection] Parsed");
            [self showDicToScreen:res withDomain:@"GetTunnelConnection"];
            
            if ([VMCheckResponseResult checkResponseOfGetTunnelConnection:res] == VMBypassTunnelSuccess){
                VMPrintlog("response of [GetTunnelConnection] is success");
                [self.svrConnect getLaunchItems];
            }
            else{
                VMPrintlog("Error occur in response of [GetTunnelConnection]");
                [self showAlertWithTitle:@"ERROR" andMessage:@"Get Tunnel Connection Error" andTag:1];}
            break;
            
        case VMGetLaunchItems:
            VMPrintlog("Response of [GetLaunchItems] received");
            res = [VMXMLParser responseOfGetLaunchItems:xmlData];
            VMPrintlog("XML of [GetLaunchItems] Parsed");
            _launchItems = res;
            
            if ([VMCheckResponseResult checkResponseOfGetLaunchItems:res] == VMGetLaunchItemSuccess){
                VMPrintlog("response of [GetLaunchItems] is success");
                VMPrintlog("The Table Of Launch Item will Show");
                [self performSegueWithIdentifier:@"table" sender:self];
            }
            else{
                VMPrintlog("Error occur in response of [GetLaunchItems]");
                [self showAlertWithTitle:@"ERROR" andMessage:@"Get Launch Items Error" andTag:1];}
            break;
        default:
            break;
    }
//   NSLog(@"xmlResponse = %@",[[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding]);
}

- (void)WebService:(VMWebService *)webService didFailWithError:(NSError *)error{
    VMPrintlog("Error occur when connect to the server");
    [self showAlertWithTitle:@"ERROR" andMessage:[error localizedDescription] andTag:4];
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //弹出的提示框为服务器地址输入框时
    if ([[alertView title] isEqualToString:INPUTSERVERADDR]) {
        if (buttonIndex == 0) {
            return;
        }
        else{
            _srvAddr = [[alertView textFieldAtIndex:0] text];
            [self.svrConnect setLocaleRequestWithString:@"en_GB"];
        }
    }
    
    //弹出的提示框为用户名和密码输入框时
    else if ([[alertView title] isEqualToString:LOGINTOSERVER]) {
        if (buttonIndex == 0)
            return; //Cancel
        else{
            _usr = [[alertView textFieldAtIndex:0] text];
            _psw = [[alertView textFieldAtIndex:1] text];
            [self.svrConnect loginWithId:_usr andPassWord:_psw andDomain:[[VMXMLParser getResultDic] objectForKey:@"domain"]];
        }
        
    }
    
    //弹出的提示框为错误警告时
    else if ([[alertView title] isEqualToString:@"ERROR"]){
        switch ([alertView tag]) {
            case 1:
                break;
            case 2:
                break;
            case 3:
                [self showUserInputFieldWithTitle:LOGINTOSERVER andMessage:[[NSUserDefaults standardUserDefaults] objectForKey:@"server_addr"]];
                break;
            case 4:
                [self showUserInputFieldWithTitle:INPUTSERVERADDR andMessage:nil];
                break;
            case 5:
                break;
            default:
                break;
        }
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView{
    if ([[alertView title] isEqualToString:INPUTSERVERADDR]) {
        VMPrintlog("Alert View Of INPUT SERVER ADDRESS Did Show");
    }
    else if ([[alertView title] isEqualToString:LOGINTOSERVER]) {
        VMPrintlog("Alert View Of LOGIN TO SERVER Did Show");
    }
    else if ([[alertView title] isEqualToString:@"ERROR"]){
        VMPrintlog("Alert View Of Error Did Show");
    }
    
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

- (void)showDicToScreen:(NSDictionary *)dic withDomain:(NSString *)domain{
    if (dic) {
        NSEnumerator *e = [dic keyEnumerator];
        id key;
        while (key = [e nextObject]) {
            [self appendStringToTextView:[NSString stringWithFormat:@"[%@]: %@ = %@",domain,(NSString *)key,(NSString *)[dic objectForKey:key]]];
        }
    }
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
    VMPrintlog("Alert View Of Error Will Show");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView setTag:tag];
    
    [alertView show];
}

//在TextView中新加一行记录
- (void)appendStringToTextView:(NSString *)str{
    static NSInteger order = 1;
    if (_clear) {
        order = 1;
        _clear = NO;
    }
    NSString *appendString = [NSString stringWithFormat:@"\n%d. ", order++];
    NSString *text = [self.logView.text stringByAppendingString:appendString];
    self.logView.text = [text stringByAppendingString:str];
}

#pragma mark - IBAction

- (IBAction)startBtnClicked:(id)sender{
    VMPrintlog("Alert View Of INPUT SERVER ADDRESS Will Show");
    [self showUserInputFieldWithTitle:INPUTSERVERADDR andMessage:nil];
}

- (IBAction)clearBtnClicked:(id)sender{
    
    [self.logView setText:[NSString stringWithFormat:@"Log Message:"]];
    _clear = YES;
}

- (IBAction)showDesktopBtnClicked:(id)sender{
    if (_launchItems) {
        [self performSegueWithIdentifier:@"table" sender:self];
    }
    else
        [self startBtnClicked:sender];
}

- (IBAction)showContentOfLogfileBtnClicked:(id)sender{
    
}

@end

//
//  VMLoginViewController.m
//  ConnectionPerformanceTest
//
//  Created by banana on 14-8-12.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import "VMLoginViewController.h"
#import "VMXMLParser.h"
#import "VMCheckResponseResult.h"
#import "VMTableViewController.h"

@interface VMLoginViewController ()

@end

@implementation VMLoginViewController{
    UIActivityIndicatorView* _aiv;
    NSInteger _distance; //屏幕移动的距离
    CGRect _frame; //保存移动前屏幕的位置
    BOOL _offset; //屏幕是否已经在偏移
    NSDictionary *_launchItems;
}

#pragma mark - UIViewController

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
    // Do any additional setup after loading the view.
    self.usrField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    self.pswField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    _offset = NO;
    _launchItems = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.usrField isFirstResponder] || [self.pswField isFirstResponder]) {
        [self.usrField resignFirstResponder];
        [self.pswField resignFirstResponder];
    }
    VMPrintlog("View Of Input Username And Password Did Show");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)dismissKeyboard:(id)sender {
    _offset = NO;
    if ([self.usrField isFirstResponder] || [self.pswField isFirstResponder]) {
        [self.usrField resignFirstResponder];
        [self.pswField resignFirstResponder];
    }
}

- (IBAction)logBtnClicked:(id)sender {
    [self performSelector:@selector(showWaitingView)];
    NSString *usr = self.usrField.text;
    NSString *psw = self.pswField.text;
    
    VMWebService *ws = [[VMWebService alloc] init];
    ws.delegate = self;
    
    [ws loginWithId:usr andPassWord:psw andDomain:[[VMXMLParser getResultDic] objectForKey:@"domain"]];
}

#pragma mark - User Defined Functions

- (void)showWaitingView {
    if (!_aiv) {
        _aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 50, [[UIScreen mainScreen] bounds].size.height/2 - 85,100,100)];
        _aiv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _aiv.color = [UIColor darkGrayColor];
        [self.view addSubview:_aiv];
    }
    [_aiv startAnimating];
}

- (void)showDesktopItems{
    VMPrintlog("View Of Desktop Will Show");
    [self performSegueWithIdentifier:@"showDesktop" sender:self];
    [_aiv stopAnimating];
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString*)message
{
    [_aiv stopAnimating];
    VMPrintlog("Alert View Of Error Will Show");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    //    [alertView setTag:tag];
    
    [alertView show];
}

#pragma mark - VMWebServiceDelegate

- (void)WebService:(VMWebService *)webService didFinishWithDictionary:(NSDictionary *)dic{
    _launchItems = dic;
    [self showDesktopItems];
    
}

- (void)WebService:(VMWebService *)webService didFailWithDictionary:(NSDictionary *)dic{
    switch (webService.type) {
        case VMDoSubmitAuthentication:
            if([VMCheckResponseResult checkResponseOfAuthentication:dic] == VMAuthenticationErrorPassword){
                [self showAlertWithTitle:@"ERROR" andMessage:[dic objectForKey:@"error"]];
            }
            else if([VMCheckResponseResult checkResponseOfAuthentication:dic] == VMAuthenticationError){
                NSString *errStr = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"error-message"],[dic objectForKey:@"user-message"]];
                [self showAlertWithTitle:@"ERROR" andMessage:errStr];
            }
            break;
        case VMGetTunnelConnection:
            [self showAlertWithTitle:@"ERROR" andMessage:@"Get Launch Items Error"];
            [self showAlertWithTitle:@"ERROR" andMessage:@"Get Tunnel Connection Error"];
            break;
        case VMGetLaunchItems:
            [self showAlertWithTitle:@"ERROR" andMessage:@"Get Launch Items Error"];
            break;
        default:
            break;
    }
    
    [_aiv stopAnimating];
}

- (void)WebService:(VMWebService *)webService didFailWithError:(NSError *)error{
    VMPrintlog("Error occur when connect to the server");
    [self showAlertWithTitle:@"ERROR" andMessage:[error localizedDescription]];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_offset) {
        return;
    }
    CGRect btnFrame =  [self.lgnBtn frame];
    NSInteger bottomY = btnFrame.origin.y + btnFrame.size.height;
    NSInteger spaceY = self.view.frame.size.height - bottomY;
    
    if(spaceY >= 224)  //判断当前的高度是否已经有224，如果超过了就不需要再移动主界面的View高度
    {
        _distance = 0;
        return;
    }
    _distance = 224 - spaceY;
    _frame = self.view.frame;
    
    CGRect frame = self.view.frame;
    frame.origin.y -= _distance;//view的Y轴上移
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
    _offset = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_distance == 0 || _offset) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = _frame;
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)didPresentAlertView:(UIAlertView *)alertView{
    VMPrintlog("Alert View Of Error Did Show");
}


#pragma mark - Navigation

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

@end

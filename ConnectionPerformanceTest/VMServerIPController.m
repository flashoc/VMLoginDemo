//
//  VMServerIPController.m
//  ConnectionPerformanceTest
//
//  Created by banana on 14-8-11.
//  Copyright (c) 2014年 VMware. All rights reserved.
//

#import "VMServerIPController.h"

@interface VMServerIPController ()

@end

@implementation VMServerIPController
{
    NSInteger _distance; //屏幕移动的距离
    CGRect _frame; //保存移动前屏幕的位置
    UIActivityIndicatorView* _aiv;
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
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[[[self navigationController] navigationBar] topItem] setTitle:[self title]];
    
    self.addrField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"server_addr"];
    
    _distance = 0;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.addrField isFirstResponder]) {
        [self.addrField resignFirstResponder];
    }
    VMPrintlog("View Of Input Server Address Did Show");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect btnFrame =  [self.nxtBtn frame];
    NSInteger bottomY = btnFrame.origin.y + btnFrame.size.height;
    NSInteger spaceY = self.view.frame.size.height - bottomY;
    
    if(spaceY >= 224)  //判断当前的高度是否已经有224，如果超过了就不需要再移动主界面的View高度
    {
        return;
    }
    _distance = 224 - spaceY;
    _frame = self.view.frame;
    
    CGRect frame = self.view.frame;
    frame.origin.y -= _distance;//view的Y轴上移
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_distance == 0) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = _frame;
    }];
}

#pragma mark - VMWebServiceDelegate

- (void)WebService:(VMWebService *)webService didFinishWithDictionary:(NSDictionary *)dic{
    if (webService.type == VMGetConfigurationRequest) {
        [self nextView];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.addrField.text forKey:@"server_addr"];
    }
}
- (void)WebService:(VMWebService *)webService didFailWithDictionary:(NSDictionary *)dic{
    switch (webService.type) {
        case VMSetLocaleRequest:
            [self showAlertWithTitle:@"ERROR" andMessage:@"SetLcale Error"];
            break;
        case VMGetConfigurationRequest:
            [self showAlertWithTitle:@"ERROR" andMessage:[dic objectForKey:@"error-message"]];
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

#pragma mark - IBAction

- (IBAction)dismissKeyboard:(id)sender {
    if ([self.addrField isFirstResponder]) {
        [self.addrField resignFirstResponder];
    }
}

- (IBAction)nextBtnClicked:(id)sender {
    [self performSelector:@selector(showWaitingView)];
    NSString *address = self.addrField.text;
    [[NSUserDefaults standardUserDefaults] setObject:address forKey:@"svr_addr"];
    VMWebService *ws = [[VMWebService alloc] init];
    ws.delegate = self;
    [ws setLocaleRequestWithString:@"en_GB"];
}

#pragma mark - User Defined Functions

- (void)nextView{
    VMPrintlog("View Of Input Username And Password Will Show");
    [self performSegueWithIdentifier:@"LoginView" sender:self];
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
    
    [alertView show];
}

- (void)showWaitingView {
    if (!_aiv) {
        _aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 50, [[UIScreen mainScreen] bounds].size.height/2 - 65,100,100)];
        _aiv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _aiv.color = [UIColor darkGrayColor];
        [self.view addSubview:_aiv];
    }
    [_aiv startAnimating];
}

#pragma mark - UIAlertViewDelegate

- (void)didPresentAlertView:(UIAlertView *)alertView{
    
    VMPrintlog("Alert View Of Error Did Show");
}

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

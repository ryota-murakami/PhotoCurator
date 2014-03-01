//
//  Auth ViewController.m
//  PhotoCurator
//
//  Created by tokyorefrain on 2014/02/14.
//  Copyright (c) 2014年 tokyorefrain. All rights reserved.
//

#import "Auth ViewController.h"


@interface Auth_ViewController ()
{
    NSData *senddata,*recivedata;
    NSString *url,*recivestr;
}
- (IBAction)tapButton:(id)sender;

@end

@implementation Auth_ViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//サーバへ認証リクエストを送信
- (IBAction)tapButton:(id)sender {
    
    
    url = [NSString stringWithFormat:@"http://tokyorefrain.local/photocurator/auth.php"];
    senddata = [@"agree" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:senddata];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    //リクエスト送信
    recivedata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
  
    
    //リクエストエラーダイアログ
    NSString *errorMessage = [error localizedDescription];
    if (0<[errorMessage length]) {
        NSString *message = [NSString stringWithFormat:@"HTTPステータスコード:%d",response.statusCode];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle : @"リクエストエラー"
                              message :message
                              delegate : nil
                              cancelButtonTitle : @"OK"
                              otherButtonTitles : nil];
                              [alert show];
    }
    
    
    //受信データを文字列に変換
    if(recivedata){
    recivestr = [[[NSString alloc] initWithData:recivedata encoding:NSUTF8StringEncoding]substringToIndex:2];
    

    //認証処理
    if([recivestr isEqualToString:@"OK"]){
       
        NSUserDefaults *database;
        database = [NSUserDefaults standardUserDefaults];
        [database setBool:YES forKey:@"agree"];
        [database synchronize];
        
        [self.delegate authEnd:self];
    }else{
       
        //レスポンスエラーダイアログ
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle : @"レスポンスエラー"
                                  message : @"エラーが発生しました"
                                  delegate : nil
                                  cancelButtonTitle : @"OK"
                                  otherButtonTitles : nil];
            [alert show];
        }
    }
    
}

@end

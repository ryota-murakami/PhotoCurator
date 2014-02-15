//
//  ViewController.m
//  PhotoCurator
//
//  Created by tokyorefrain on 2014/02/12.
//  Copyright (c) 2014年 tokyorefrain. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
-(void)photoButtonTaped:(UIBarButtonItem*)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    //初回起動時に利用規約を表示する
    NSUserDefaults *database = [NSUserDefaults standardUserDefaults];
    BOOL agree = [database boolForKey:@"agree"];
    
    if(!agree){
        [self performSegueWithIdentifier:@"Auth" sender:self];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    //左上のボタン
    UIBarButtonItem *photoButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(photoButtonTaped:)];
    self.navigationItem.leftBarButtonItem = photoButton;
    
    //検索バー
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.placeholder = @"場所/住所を検索";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Auth_ViewController

-(void)authEnd:(Auth_ViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -

#pragma mark segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController]setDelegate:self];
}
#pragma mark -

#pragma mark photoViewController

-(void)photoButtonTaped:(UIBarButtonItem*)sender
{
    NSLog(@"photoボタン");
}
#pragma mark -






@end

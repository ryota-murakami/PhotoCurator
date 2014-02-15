//
//  ViewController.m
//  PhotoCurator
//
//  Created by tokyorefrain on 2014/02/12.
//  Copyright (c) 2014年 tokyorefrain. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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

    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)authEnd:(Auth_ViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController]setDelegate:self];
}


@end

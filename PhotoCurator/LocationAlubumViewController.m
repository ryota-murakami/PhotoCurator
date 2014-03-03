//
//  LocationAlubumViewController.m
//  PhotoCurator
//
//  Created by tokyorefrain on 2014/02/27.
//  Copyright (c) 2014年 tokyorefrain. All rights reserved.
//

#import "LocationAlubumViewController.h"

@interface LocationAlubumViewController ()
{
    NSMutableArray *_albumList;
}
@end

@implementation LocationAlubumViewController

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
    
    //タイトル
    self.navigationItem.title = @"アルバム";
    
    //右上のボタン
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addbuttonTapped)];
    self.navigationItem.rightBarButtonItem = addButton;



}

//ピンの座標に既にあるアルバムを読み込む
-(void)viewWillAppear:(BOOL)animated
{

    //USerDefaultに保存したインスタンス変数_albumListを読み込む
    NSUserDefaults *database = [NSUserDefaults standardUserDefaults];
    NSData *data = [database dataForKey:@"albumList"];
    NSMutableArray *allAlbumList = [[NSMutableArray alloc]init];
    allAlbumList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if(!_albumList){
        _albumList = [[NSMutableArray alloc]init];
    }
    
    //ピンの座標とlocationプロパティが同じアルバムをインスタンス変数_albumListに抽出
    for(AlbumData *albumdata in allAlbumList){
        
        if(albumdata.location.latitude == _pinCoordinate.latitude && albumdata.location.longitude == _pinCoordinate.longitude){
                [_albumList addObject:albumdata];
        }
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return _albumList.count;
}

//アルバム名のセルを追加
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [_albumList enumerateObjectsUsingBlock:^(AlbumData *album, NSUInteger idx, BOOL *stop){
        if(idx == indexPath.row){
            cell.textLabel.text = album.title;
            *stop = YES;
        }
    }];
    
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */



//＋ボタンから新規アルバムを作成
-(void)addbuttonTapped
{
    UIAlertView *nameAlert = [[UIAlertView alloc]initWithTitle:@"アルバム名を入力して下さい" message:@"20文字以内です" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"作成", nil];
    nameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [nameAlert show];
}
#pragma mark UIAlertViewDelegate

//作成ボタンの文字数制限
-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *fld =[alertView textFieldAtIndex:0];
    if([fld.text length] <= 20 && [fld.text length] >= 1){
        return YES;
    }else{
        return NO;
    }
}

//作成ボタンタップ後
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            
        case 1:
           
            if(!_albumList){
                _albumList = [[NSMutableArray alloc] init];
            }
            
            //新規アルバムに名前と位置情報をセット
            AlbumData *newAlbum = [[AlbumData alloc]initWithTitle:[alertView textFieldAtIndex:0].text location:_pinCoordinate];
            
            //インスタンス変数に新規アルバムを格納
            [_albumList insertObject:newAlbum atIndex:0];
            
            //NSuserDefaultにインスタンス変数を格納
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_albumList];
            NSUserDefaults *database = [NSUserDefaults standardUserDefaults];
            [database setObject:data forKey:@"albumList"];
            [database synchronize];
            
            //セルの挿入位置
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            break;
    }

}

#pragma mark -



//ピンの位置を取得
-(void)pinCoordinate:(CLLocationCoordinate2D)coordinate
{
    _pinCoordinate = coordinate;
}




@end

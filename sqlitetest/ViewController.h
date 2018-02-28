//
//  ViewController.h
//  sqlitetest
//
//  Created by Felix-ITS 004 on 05/01/18.
//  Copyright © 2018 sonal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    sqlite3 *taskDatabase;
}



@property (strong, nonatomic) IBOutlet UITableView *mytableView;
- (IBAction)insertBtnActoin:(id)sender;
- (IBAction)updateBtnAction:(id)sender;
- (IBAction)deleteBtnAciton:(id)sender;
- (IBAction)searchBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *itemNametextField;
@property (strong, nonatomic) IBOutlet UITextField *itemRateTextField;

@property(nonatomic,retain)NSMutableArray *IDArray;
@property(nonatomic,retain) NSMutableArray *tasknamearray;


-(void)createDatabase;
-(BOOL)executeQuery:(NSString *)query;
-(void)getAlltasks:(NSString *)query;
-(NSString *)getDatabasePath;


@end


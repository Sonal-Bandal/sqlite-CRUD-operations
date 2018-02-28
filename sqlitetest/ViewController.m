//
//  ViewController.m
//  sqlitetest
//
//  Created by Felix-ITS 004 on 05/01/18.
//  Copyright © 2018 sonal. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDatabase];
    NSString *selectQuery=@"select taskId,taskName from taskTable";
    [self getAlltasks:selectQuery];
    if(self.tasknamearray.count >0)
    {
        self.mytableView.delegate=self;
        self.mytableView.dataSource=self;
    }
    NSLog(@"DISHES INSERTED ARE %@",self.tasknamearray);
    
}
-(void)createDatabase
{
    NSString *createQuery=@"create table if not exists taskTable(taskId text,taskName text)";
    BOOL success=[self executeQuery:createQuery];
    if(success)
    {
        NSLog(@"Table created");
    }
}
-(NSString *)getDatabasePath
{
    NSArray *docArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[[docArray firstObject]stringByAppendingString:@"/myTaskDatabase.db"];
    //NSString *docPath=[NSString stringWithFormat:@"%@/myTaskDatabase.db",[docArray lastObject]];
    NSLog(@"%@",docPath);
    return docPath;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)insertBtnActoin:(id)sender
{
    NSString *insertQuery=[NSString stringWithFormat:@"insert into taskTable(taskId,taskName) values('%@','%@')",self.itemRateTextField.text,self.itemNametextField.text];
    BOOL isSucess= [self executeQuery:insertQuery];
    if(isSucess && self.tasknamearray.count >0)
        
    {
        NSString *selectQuery=@"select taskId,taskName from taskTable";
        
        
        [self getAlltasks:selectQuery];
        
        [self.mytableView reloadData];
    }
    
    NSLog(@" insert query is :%@",insertQuery);
}

- (IBAction)updateBtnAction:(id)sender
{
//    NSString *str = self.itemNametextField.text;
//    int id = [str intValue];
//    NSString *tnstr = self.itemRateTextField.text;
//    //NSInteger c = _taskNameArray.count;
//    
    NSString *updateQuery=[NSString stringWithFormat:@"update taskTable set taskId = '%@' where taskName = '%@'",self.itemRateTextField.text,self.itemNametextField.text];
    
    BOOL isSucess= [self executeQuery:updateQuery];
    
    if(isSucess && self.tasknamearray.count >0)
    {
       // [self executeQuery:updateQuery];
        
        NSString *selectQuery=@"select taskId,taskName from taskTable";
        
        
        [self getAlltasks:selectQuery];
        
        [self.mytableView reloadData];
    }
    
    NSLog(@" updated query is :%@",updateQuery);
    
    

}

- (IBAction)deleteBtnAciton:(id)sender
{
//    NSString *str = self.itemNametextField.text;
//    int id = [str intValue];
    NSString *deleteSQL = [NSString stringWithFormat:@"delete from taskTable where taskName='%@'",self.itemNametextField.text];

    NSInteger c = self.tasknamearray.count;
    
    BOOL isSucess= [self executeQuery:deleteSQL];
    
    if(isSucess && c>0)
    {
//        [self executeQuery:deleteSQL];
       NSString *selectQuery=@"select taskId,taskName from taskTable";
        c--;
        // _taskNameArray.count-=1;
        [self getAlltasks:selectQuery];
       // if(c>0)
       // {
            [self.mytableView reloadData];
        NSLog(@"done");
        //}

    }
    
    
   

}

-(void)getAlltasks:(NSString *)query
{
    self.tasknamearray=[[NSMutableArray alloc]init];
    self.IDArray = [[NSMutableArray alloc]init];
    
    sqlite3_stmt *statement;
    const char *cQuery=[query UTF8String];
    const char *databasePath=[[self getDatabasePath] UTF8String];
    if(sqlite3_open(databasePath,&taskDatabase)==SQLITE_OK)
    {
        if(sqlite3_prepare_v2(taskDatabase,cQuery,-1,&statement,NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW)
            {
                unsigned const char *tName=sqlite3_column_text(statement,1);
                NSString *tasknm=[NSString stringWithFormat:@"%s",tName];
                [self.tasknamearray addObject:tasknm];
                
                unsigned const char *tID=sqlite3_column_text(statement,0);
                NSString *taskID=[NSString stringWithFormat:@"%s",tID];
                [self.IDArray addObject:taskID];
                
                
            }
            
        }
        else
        {
            NSLog(@"%s in sqlite prepare v2",sqlite3_errmsg(taskDatabase));
            
        }
    }
    else
    {
        NSLog(@"%s in sqlite opening database",sqlite3_errmsg(taskDatabase));
    }
    sqlite3_close(taskDatabase);
    sqlite3_finalize(statement);
    
}


-(BOOL)executeQuery:(NSString *)query
{
    BOOL success=0;
    sqlite3_stmt *statement;
    const char *cQuery=[query UTF8String];
    const char *databasePath=[[self getDatabasePath] UTF8String];
    if(sqlite3_open(databasePath,&taskDatabase)==SQLITE_OK)
    {
        if(sqlite3_prepare_v2(taskDatabase,cQuery,-1,&statement,NULL)==SQLITE_OK)
        {
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                success=1;
            }
            else
            {
                NSLog(@"%s in sqlite step",sqlite3_errmsg(taskDatabase));
            }
        }
        else
        {
            NSLog(@"%s in sqlite prepare v2",sqlite3_errmsg(taskDatabase));
            
        }
    }
    else
    {
        NSLog(@"%s in sqlite opening database",sqlite3_errmsg(taskDatabase));
        
    }
    sqlite3_close(taskDatabase);
    sqlite3_finalize(statement);
    return success;
}



- (IBAction)searchBtnAction:(id)sender
{
    
    NSString *searchQuery=@"select * from taskTable";
    BOOL success=[self executeQuery:searchQuery];
    if (success && self.tasknamearray.count>0) {
        [self getAlltasks:searchQuery];
        NSLog(@"DETAILS ARE:%@",self.tasknamearray);
        [self.mytableView reloadData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tasknamearray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text= [self.tasknamearray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.IDArray objectAtIndex:indexPath.row];
    cell.imageView.image=[UIImage imageNamed:@"pizzaa.jpg"];
    NSLog(@"%@",[self.tasknamearray objectAtIndex:indexPath.row]);
    return cell;
}
@end

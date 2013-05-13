//
//  AddCellsBetweenCellsController.m
//  AddCellsBetweenCellsController
//
//  Created by sato daisuke on 13/05/13.
//  Copyright (c) 2013年 sato daisuke. All rights reserved.
//

#import "AddCellsBetweenCellsController.h"

@interface AddCellsBetweenCellsController ()
@property(nonatomic,retain,readwrite)NSMutableArray *dataSource;


@end

@implementation AddCellsBetweenCellsController
{
@private
    NSMutableArray *_dataSource;
    BOOL isTouched;
    NSArray *additionalData1,*additionalData2; //will be added
    int tmp;
}
@synthesize table;
@synthesize dataSource = _dataSource;

-(id)init{
    
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //deselect cell
    [self.table deselectRowAtIndexPath:[self.table indexPathForSelectedRow] animated:YES];
    //upadte dataSource
    [self updateDataSource];
    //update visible cells
    [self updateVisibleCells];
}
-(void)updateDataSource{
    self.dataSource = [NSMutableArray arrayWithObjects:@"hoge1",@"hoge2",@"hoge3",@"hoge4",@"hoge5",nil];
}

//reload the visible cells
-(void)updateVisibleCells{
    for(UITableViewCell * cell in [self.table visibleCells]){
        [self updateCell:cell atIndexPath:[self.table indexPathForCell:cell]];
    }
}
//Update Cells
-(void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *text = [self.dataSource objectAtIndex:(NSUInteger) indexPath.row];
    cell.textLabel.text = text;
    NSString *detailText = @"Subtitle";
    cell.detailTextLabel.text = detailText;
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
    
}


-(void)loadView{
    
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    table = [[UITableView alloc]initWithFrame:view.bounds style:UITableViewStylePlain];
    table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    table.dataSource = self;
    table.delegate = self;
    [view addSubview:table];
    
    //isTouchedAt1 = NO;
    
    //An element of this array will be added in between the cells
    additionalData1 = [[NSArray alloc]initWithObjects:@"Added cell1-1",@"Added cell1-2",@"Added cell1-3",@"Added cell1-4",@"Added cell1-5", nil];
    additionalData2 = [[NSArray alloc]initWithObjects:@"Added cell2-1",@"Added cell2-2",@"Added cell2-3",@"Added cell2-4",@"Added cell2-5", nil];
    
    self.view = view;
    [view release];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //return the number of sections.
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
    }
    
    //Update cell
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//set the height of a cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(isTouched == NO){
        //add two elements between the cells
        //For last element
        if([self.dataSource count] == indexPath.row){
            [self.dataSource addObject:[additionalData1 objectAtIndex:indexPath.row]];
            [self.dataSource addObject:[additionalData2 objectAtIndex:indexPath.row]];
        }
        //For the others except a last one
        else{
            [self.dataSource insertObject:[additionalData1 objectAtIndex:indexPath.row] atIndex:indexPath.row+1];
            [self.dataSource insertObject:[additionalData2 objectAtIndex:indexPath.row] atIndex:indexPath.row+2];
        }
        isTouched = YES;
        tmp = indexPath.row;
        
    }
    
    else if(isTouched == YES){
        
        //when tap the same cell in a second time.
        if(tmp == indexPath.row){
            
            //remove the added elements
            [self.dataSource removeObjectAtIndex:indexPath.row+1];
            [self.dataSource removeObjectAtIndex:indexPath.row+1];
            
            isTouched = NO;
        }
        //when tap other cell in a second time
        //doesn't do this process if tap the added cell like the elements of both additionalData1 and additionalData2.
        else if(tmp != indexPath.row && tmp+1 != indexPath.row && tmp+2 != indexPath.row){
            //remove the added elements
            [self.dataSource removeObjectAtIndex:tmp+1];
            [self.dataSource removeObjectAtIndex:tmp+1];
            //For the last cell.
            if([self.dataSource count] == indexPath.row-2){
                [self.dataSource addObject:[additionalData1 objectAtIndex:indexPath.row-2]];
                [self.dataSource addObject:[additionalData2 objectAtIndex:indexPath.row-2]];
                tmp = indexPath.row -2;
            }
            //For others
            else{
                
                if(indexPath.row == 0){
                    [self.dataSource insertObject:[additionalData1 objectAtIndex:0] atIndex:1];
                    [self.dataSource insertObject:[additionalData2 objectAtIndex:0] atIndex:2];
                    tmp = indexPath.row;
                }
                else if(tmp < indexPath.row){
                    [self.dataSource insertObject:[additionalData1 objectAtIndex:indexPath.row-2] atIndex:indexPath.row -1];
                    [self.dataSource insertObject:[additionalData2 objectAtIndex:indexPath.row-2] atIndex:indexPath.row];
                    tmp = indexPath.row -2;
                }
                else if(tmp > indexPath.row){
                    [self.dataSource insertObject:[additionalData1 objectAtIndex:indexPath.row] atIndex:indexPath.row+1];
                    [self.dataSource insertObject:[additionalData2 objectAtIndex:indexPath.row] atIndex:indexPath.row+2];
                    tmp = indexPath.row;
                }
            }
            
            isTouched = YES;
        }
        
    }
    
    
    //reload the data of the table.
    [table reloadData];
    return indexPath;
}

-(void)dealloc{
    [table release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



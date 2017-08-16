//
//  scanDeviceTableViewController.m
//  bR500Sample
//
//  Created by ftsafe on 16/1/20.
//  Copyright  (C)2016-2020 Feitian Technologies Co. ,Ltd. All rights reserved.
//

#import "scanDeviceTableViewController.h"
#import "indicate.h"

@interface scanDeviceTableViewController ()
{
    __block indicate *indicateView;
    BOOL isAttached;
}

//@property(nonatomic,assign) BOOL isAttached;

@end

SCARDCONTEXT gContxtHandle;
@implementation scanDeviceTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    _deviceListArray = [[NSMutableArray alloc] init];
    _readerInfo = [[ReaderInterface alloc] init];
    [_readerInfo setDelegate:self];
    [self.tableView  reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"bR500_and_bR301BLE";
}

/**
 *  display indicate view
 */
-(void)createIndicateView
{
    if (indicateView == nil) {
        indicateView = [[indicate alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 100.0f)];
        indicateView.center = self.view.center;
        [self.view addSubview:indicateView];
    }else{
        indicateView.hidden = NO;
    }
    
    self.tableView.userInteractionEnabled = NO;
}

/**
 *  hide Indicate view
 */
-(void)hidIndicateView
{
    indicateView.hidden = YES;
    self.tableView.userInteractionEnabled = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - readerInterfaceDelegate
-(void)findPeripheralReader:(NSString *)readerName{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createIndicateView];
    });
    
    if (_deviceListArray == nil) {
        _deviceListArray = [[NSMutableArray alloc] init];
    }
    
    if ([readerName length] == 0) {
        return;
    }
    
    for (int i = 0; i < [_deviceListArray count]; i++) {
        if ([_deviceListArray[i] isEqualToString:readerName]) {
            return;
        }
    }
    
    [_deviceListArray addObject:readerName];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self hidIndicateView];
    });
    
}

-(void)readerInterfaceDidChange:(BOOL)attached
{
    if (attached) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hidIndicateView];
            [self performSegueWithIdentifier:@"reader_attatch" sender:self];
        });
    }else{
        
        for (NSString *deviceName in _deviceListArray) {
            if ([deviceName isEqualToString:_selectReaderName]) {
                [_deviceListArray removeObject:deviceName];
                break;
            }
        }
        //update tableview list
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self hidIndicateView];
        });
    }

}

-(void)cardInterfaceDidDetach:(BOOL)attached
{
    isAttached = attached;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_deviceListArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"scanDeviceList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = _deviceListArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self createIndicateView];
    _selectReaderName =  _deviceListArray[indexPath.row];
	BOOL flag = [_readerInfo connectPeripheralReader:_deviceListArray[indexPath.row] timeout:5];
    if(flag == NO){
        
        NSLog(@"connect fail");
        [self hidIndicateView];
    }
}

#pragma mark - stroyboard
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    //1.enter connect reader view
    if ([identifier isEqualToString:@"reader_attatch"]) {
        return NO;
    }
    return YES;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    mainViewController *controller = segue.destinationViewController;
    controller.currentReaderName = _selectReaderName;
    controller.cardIsAttached = isAttached;
}

@end
